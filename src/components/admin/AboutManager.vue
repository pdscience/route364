<template>
  <AdminLayout>
    <h1 class="text-3xl font-bold mb-8">Gerenciar Sobre Nós</h1>

    <div class="clay-card p-8 mb-8">
      <form @submit.prevent="saveAbout" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Prefixo do Título</label>
            <input v-model="form.titlePrefix" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Destaque do Título</label>
            <input v-model="form.titleHighlight" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Sufixo do Título</label>
            <input v-model="form.titleSuffix" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-400 mb-2">Descrição</label>
          <textarea v-model="form.description" rows="4" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"></textarea>
        </div>
        <button type="submit" class="clay-btn py-3 px-8">
          Salvar Alterações
        </button>
      </form>
    </div>

    <h2 class="text-2xl font-bold mb-6">Gerenciar Características</h2>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
      <div v-for="feature in features" :key="feature.id" class="clay-card p-6">
        <div class="flex justify-between items-start mb-4">
          <div>
            <h3 class="font-bold text-white">{{ feature.title }}</h3>
            <p class="text-sm text-gray-400">{{ feature.description }}</p>
          </div>
          <span :class="`px-3 py-1 rounded-full text-xs font-medium capitalize bg-brand-${feature.color}/10 text-brand-${feature.color}`">
            {{ feature.color }}
          </span>
        </div>
        <button @click="openFeatureModal(feature)" class="text-brand-blue hover:text-brand-blue/80 text-sm">Editar</button>
      </div>
    </div>

    <div v-if="showFeatureModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
      <div class="clay-card p-8 w-full max-w-lg">
        <h2 class="text-2xl font-bold mb-6">Editar Característica</h2>
        <form @submit.prevent="saveFeature" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Título</label>
            <input v-model="featureForm.title" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Descrição</label>
            <textarea v-model="featureForm.description" rows="3" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"></textarea>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Ícone</label>
            <select v-model="featureForm.icon" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none">
              <option value="monitor">Monitor</option>
              <option value="award">Prêmio</option>
              <option value="users">Usuários</option>
              <option value="clock">Relógio</option>
            </select>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Cor</label>
            <select v-model="featureForm.color" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none">
              <option value="yellow">Amarelo</option>
              <option value="gold">Dourado</option>
              <option value="green">Verde</option>
              <option value="blue">Azul</option>
            </select>
          </div>
          <div class="flex gap-4 pt-4">
            <button type="button" @click="closeFeatureModal" class="flex-1 py-3 rounded-xl border border-white/10 text-gray-400 hover:bg-white/5 transition-colors">Cancelar</button>
            <button type="submit" class="flex-1 py-3 rounded-xl clay-btn">Salvar</button>
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
import type { Feature, AboutData } from '../../types';

const { aboutData, features, updateAboutData, updateFeature } = useContent();

const form = ref<AboutData>({ ...aboutData.value });
const showFeatureModal = ref(false);
const editingFeature = ref<Feature | null>(null);
const featureForm = ref({
  title: '',
  description: '',
  icon: 'monitor' as 'monitor' | 'award' | 'users' | 'clock',
  color: 'yellow' as 'yellow' | 'green' | 'blue' | 'gold'
});

const saveAbout = () => {
  updateAboutData(form.value);
  alert('Alterações salvas com sucesso!');
};

const openFeatureModal = (feature: Feature) => {
  editingFeature.value = feature;
  featureForm.value = { ...feature };
  showFeatureModal.value = true;
};

const closeFeatureModal = () => {
  showFeatureModal.value = false;
  editingFeature.value = null;
};

const saveFeature = () => {
  if (editingFeature.value) {
    updateFeature({ ...editingFeature.value, ...featureForm.value });
  }
  closeFeatureModal();
};
</script>
