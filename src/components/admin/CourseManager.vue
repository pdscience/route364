<template>
  <AdminLayout>
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold">Gerenciar Cursos</h1>
      <button 
        @click="openModal()"
        class="clay-btn py-2 px-6"
      >
        Novo Curso
      </button>
    </div>

    <div class="clay-card overflow-hidden">
      <table class="w-full">
        <thead class="bg-white/5">
          <tr>
            <th class="px-6 py-4 text-left text-sm font-bold text-gray-400 uppercase">Curso</th>
            <th class="px-6 py-4 text-left text-sm font-bold text-gray-400 uppercase">Categoria</th>
            <th class="px-6 py-4 text-left text-sm font-bold text-gray-400 uppercase">Cor</th>
            <th class="px-6 py-4 text-right text-sm font-bold text-gray-400 uppercase">Ações</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="course in courses" :key="course.id" class="border-t border-white/5 hover:bg-white/5 transition-colors">
            <td class="px-6 py-4">
              <div class="flex items-center gap-4">
                <img :src="course.imageUrl" :alt="course.title" class="w-16 h-16 object-cover rounded-lg" />
                <div>
                  <h3 class="font-bold text-white">{{ course.title }}</h3>
                  <p class="text-sm text-gray-400">{{ course.description.substring(0, 50) }}...</p>
                </div>
              </div>
            </td>
            <td class="px-6 py-4">
              <span class="px-3 py-1 rounded-full bg-brand-gold/10 text-brand-gold text-sm font-medium">
                {{ course.category }}
              </span>
            </td>
            <td class="px-6 py-4">
              <span :class="`px-3 py-1 rounded-full text-sm font-medium capitalize bg-brand-${course.accentColor}/10 text-brand-${course.accentColor}`">
                {{ course.accentColor }}
              </span>
            </td>
            <td class="px-6 py-4 text-right">
              <button 
                @click="openModal(course)"
                class="text-brand-blue hover:text-brand-blue/80 mr-4"
              >
                Editar
              </button>
              <button 
                @click="deleteCourse(course.id)"
                class="text-red-400 hover:text-red-300"
              >
                Excluir
              </button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <div v-if="showModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="clay-card p-8 w-full max-w-lg">
        <h2 class="text-2xl font-bold mb-6">{{ editingCourse ? 'Editar' : 'Novo' }} Curso</h2>
        <form @submit.prevent="saveCourse" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Título</label>
            <input v-model="form.title" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Descrição</label>
            <textarea v-model="form.description" rows="3" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Categoria</label>
            <input v-model="form.category" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Imagem do Curso</label>
            <div class="flex items-center gap-4">
              <div class="relative">
                <img 
                  :src="imagePreview || form.imageUrl" 
                  alt="Course image preview" 
                  class="w-20 h-20 object-cover rounded-lg border-2 border-brand-gold/30"
                />
                <div v-if="imagePreview" class="absolute inset-0 bg-black/50 rounded-lg flex items-center justify-center">
                  <span class="text-xs text-white">Preview</span>
                </div>
              </div>
              <div class="flex-1">
                <input 
                  type="file" 
                  accept="image/*"
                  @change="handleImageChange"
                  class="w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:clay-btn cursor-pointer"
                />
                <p class="text-xs text-gray-500 mt-1">Selecione uma imagem (JPG, PNG, GIF)</p>
              </div>
            </div>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Cor de Destaque</label>
            <div class="relative">
              <select v-model="form.accentColor" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none appearance-none bg-brand-dark cursor-pointer pr-10">
                <option value="yellow" class="bg-brand-dark text-white">Amarelo</option>
                <option value="gold" class="bg-brand-dark text-white">Dourado</option>
                <option value="green" class="bg-brand-dark text-white">Verde</option>
                <option value="blue" class="bg-brand-dark text-white">Azul</option>
              </select>
              <ChevronDown class="absolute right-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400 pointer-events-none" />
            </div>
          </div>
          <div class="flex gap-4 pt-4">
            <button type="button" @click="closeModal" class="flex-1 py-3 rounded-xl border border-white/10 text-gray-400 hover:bg-white/5 transition-colors">Cancelar</button>
            <button type="submit" class="flex-1 py-3 rounded-xl clay-btn" :disabled="isSaving">
              {{ isSaving ? 'Salvando...' : 'Salvar' }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { ChevronDown } from 'lucide-vue-next';
import AdminLayout from './AdminLayout.vue';
import { useContent } from '../../composables/useContent';
import { contentApi } from '../../api/contentApi';
import type { Course } from '../../types';

const { courses, addCourse, updateCourse, deleteCourse } = useContent();

const showModal = ref(false);
const editingCourse = ref<Course | null>(null);
const imagePreview = ref<string>('');
const imageFile = ref<File | null>(null);
const isSaving = ref(false);

const form = ref({
  title: '',
  description: '',
  category: '',
  imageUrl: '',
  accentColor: 'yellow' as 'yellow' | 'green' | 'blue' | 'gold'
});

const handleImageChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  if (file) {
    console.log('File selected:', file.name, file.size, file.type);
    imageFile.value = file;
    imagePreview.value = URL.createObjectURL(file);
    console.log('imageFile set:', imageFile.value);
  }
};

const openModal = (course?: Course) => {
  if (course) {
    editingCourse.value = course;
    form.value = { ...course };
  } else {
    editingCourse.value = null;
    form.value = {
      title: '',
      description: '',
      category: '',
      imageUrl: '',
      accentColor: 'yellow'
    };
  }
  imagePreview.value = '';
  imageFile.value = null;
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  editingCourse.value = null;
  imagePreview.value = '';
  imageFile.value = null;
};

const saveCourse = async () => {
  isSaving.value = true;
  try {
    console.log('Saving course...', { imageFile: imageFile.value, formImageUrl: form.value.imageUrl });
    let imageUrl = form.value.imageUrl;
    
    if (imageFile.value) {
      console.log('Uploading new course image...');
      imageUrl = await contentApi.uploadCourseImage(imageFile.value);
      console.log('New image URL:', imageUrl);
    } else {
      console.log('Using existing image URL:', imageUrl);
    }
    
    const courseData = {
      ...form.value,
      imageUrl
    };
    
    if (editingCourse.value) {
      await updateCourse({ ...editingCourse.value, ...courseData });
    } else {
      await addCourse(courseData);
    }
    closeModal();
  } catch (error) {
    console.error('Error saving course:', error);
    alert('Erro ao salvar curso. Tente novamente.');
  } finally {
    isSaving.value = false;
  }
};
</script>
