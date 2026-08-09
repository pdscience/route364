<template>
  <AdminLayout>
    <div class="flex justify-between items-center mb-8">
      <h1 class="text-3xl font-bold">Gerenciar Depoimentos</h1>
      <button 
        @click="openModal()"
        class="clay-btn py-2 px-6"
      >
        Novo Depoimento
      </button>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <div v-for="testimonial in testimonials" :key="testimonial.id" class="clay-card p-6">
        <div class="flex items-start gap-4 mb-4">
          <img :src="testimonial.avatarUrl" :alt="testimonial.name" class="w-16 h-16 rounded-full object-cover border-4 border-brand-gold/30" />
          <div>
            <h3 class="font-bold text-white">{{ testimonial.name }}</h3>
            <p class="text-sm text-brand-gold">{{ testimonial.role }}</p>
          </div>
        </div>
        <p class="text-gray-400 text-sm mb-4">"{{ testimonial.content }}"</p>
        <div class="flex gap-4">
          <button @click="openModal(testimonial)" class="text-brand-blue hover:text-brand-blue/80 text-sm">Editar</button>
          <button @click="deleteTestimonial(testimonial.id)" class="text-red-400 hover:text-red-300 text-sm">Excluir</button>
        </div>
      </div>
    </div>

    <div v-if="showModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="clay-card p-8 w-full max-w-lg">
        <h2 class="text-2xl font-bold mb-6">{{ editingTestimonial ? 'Editar' : 'Novo' }} Depoimento</h2>
        <form @submit.prevent="saveTestimonial" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Nome</label>
            <input v-model="form.name" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Cargo/Função</label>
            <input v-model="form.role" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Depoimento</label>
            <textarea v-model="form.content" rows="4" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Foto do Avatar</label>
            <div class="flex items-center gap-4">
              <div class="relative">
                <img 
                  :src="avatarPreview || form.avatarUrl" 
                  alt="Avatar preview" 
                  class="w-20 h-20 rounded-full object-cover border-2 border-brand-gold/30"
                />
                <div v-if="avatarPreview" class="absolute inset-0 bg-black/50 rounded-full flex items-center justify-center">
                  <span class="text-xs text-white">Preview</span>
                </div>
              </div>
              <div class="flex-1">
                <input 
                  type="file" 
                  accept="image/*"
                  @change="handleAvatarChange"
                  class="w-full text-sm text-gray-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:clay-btn cursor-pointer"
                />
                <p class="text-xs text-gray-500 mt-1">Selecione uma imagem (JPG, PNG, GIF)</p>
              </div>
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
import AdminLayout from './AdminLayout.vue';
import { useContent } from '../../composables/useContent';
import { contentApi } from '../../api/contentApi';
import type { Testimonial } from '../../types';

const { testimonials, addTestimonial, updateTestimonial, deleteTestimonial } = useContent();

const showModal = ref(false);
const editingTestimonial = ref<Testimonial | null>(null);
const avatarPreview = ref<string>('');
const avatarFile = ref<File | null>(null);
const isSaving = ref(false);

const form = ref({
  name: '',
  role: '',
  content: '',
  avatarUrl: ''
});

const handleAvatarChange = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const file = target.files?.[0];
  if (file) {
    console.log('Avatar file selected:', file.name, file.size, file.type);
    avatarFile.value = file;
    avatarPreview.value = URL.createObjectURL(file);
  }
};

const openModal = (testimonial?: Testimonial) => {
  if (testimonial) {
    editingTestimonial.value = testimonial;
    form.value = { ...testimonial };
  } else {
    editingTestimonial.value = null;
    form.value = {
      name: '',
      role: '',
      content: '',
      avatarUrl: 'https://i.pravatar.cc/150?u=new'
    };
  }
  avatarPreview.value = '';
  avatarFile.value = null;
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  editingTestimonial.value = null;
  avatarPreview.value = '';
  avatarFile.value = null;
};

const saveTestimonial = async () => {
  isSaving.value = true;
  try {
    console.log('Saving testimonial...', { avatarFile: avatarFile.value, formAvatarUrl: form.value.avatarUrl });
    let avatarUrl = form.value.avatarUrl;
    
    if (avatarFile.value) {
      console.log('Uploading new testimonial avatar...');
      avatarUrl = await contentApi.uploadTestimonialAvatar(avatarFile.value);
      console.log('New avatar URL:', avatarUrl);
    } else {
      console.log('Using existing avatar URL:', avatarUrl);
    }
    
    const testimonialData = {
      ...form.value,
      avatarUrl
    };
    
    if (editingTestimonial.value) {
      await updateTestimonial({ ...editingTestimonial.value, ...testimonialData });
    } else {
      await addTestimonial(testimonialData);
    }
    closeModal();
  } catch (error) {
    console.error('Error saving testimonial:', error);
    alert('Erro ao salvar depoimento. Tente novamente.');
  } finally {
    isSaving.value = false;
  }
};
</script>
