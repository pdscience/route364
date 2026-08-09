<template>
  <AdminLayout>
    <h1 class="text-3xl font-bold mb-8">Gerenciar Contato</h1>

    <div class="clay-card p-8 mb-8">
      <form @submit.prevent="saveContact" class="space-y-6">
        <div>
          <label class="block text-sm font-medium text-gray-400 mb-2">Título da Seção</label>
          <input v-model="form.sectionTitle" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
        </div>
        
        <div>
          <label class="block text-sm font-medium text-gray-400 mb-2">Endereço</label>
          <textarea v-model="form.address" rows="2" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"></textarea>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">E-mail</label>
            <input v-model="form.email" type="email" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Telefone</label>
            <input v-model="form.phone" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Número WhatsApp (somente números)</label>
            <input v-model="form.whatsappNumber" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" placeholder="5569999999999" />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Label do Link de Suporte</label>
            <input v-model="form.whatsappLinkLabel" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" />
          </div>
        </div>

        <button type="submit" class="clay-btn py-3 px-8">
          Salvar Alterações
        </button>
      </form>
    </div>

    <h2 class="text-2xl font-bold mb-6">Redes Sociais</h2>
    <div class="clay-card p-8">
      <form @submit.prevent="saveSocial" class="space-y-6">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Facebook</label>
            <input v-model="socialForm.facebook" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" placeholder="https://facebook.com/..." />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Instagram</label>
            <input v-model="socialForm.instagram" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" placeholder="https://instagram.com/..." />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">LinkedIn</label>
            <input v-model="socialForm.linkedin" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" placeholder="https://linkedin.com/..." />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-400 mb-2">Twitter</label>
            <input v-model="socialForm.twitter" type="text" class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none" placeholder="https://twitter.com/..." />
          </div>
        </div>
        <button type="submit" class="clay-btn py-3 px-8">
          Salvar Redes Sociais
        </button>
      </form>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue';
import AdminLayout from './AdminLayout.vue';
import { useContent } from '../../composables/useContent';

const { contactInfo, footerConfig, updateContactInfo, updateFooterConfig } = useContent();

const form = ref({ ...contactInfo.value });
const socialForm = reactive({ ...footerConfig.value.socialLinks });

const saveContact = () => {
  updateContactInfo(form.value);
  alert('Contato salvo com sucesso!');
};

const saveSocial = () => {
  updateFooterConfig({
    ...footerConfig.value,
    socialLinks: { ...socialForm }
  });
  alert('Redes sociais salvas com sucesso!');
};
</script>
