<template>
  <div class="min-h-screen bg-brand-dark flex items-center justify-center px-4">
    <div class="clay-card p-8 w-full max-w-md">
      <div class="text-center mb-8">
        <div class="w-20 h-20 clay-light rounded-full flex items-center justify-center mx-auto mb-4" aria-label="Ícone de cadeado">
          <Lock :size="32" class="text-brand-gold" />
        </div>
        <h1 class="text-2xl font-bold text-white uppercase tracking-wide">Acesso Administrativo</h1>
        <p class="text-gray-400 text-sm mt-2">Entre com suas credenciais para gerenciar o site</p>
      </div>

      <form @submit.prevent="handleLogin" class="space-y-6">
        <div v-if="error" class="clay-btn-danger p-3 flex items-center gap-2 text-red-400 text-sm">
          <AlertCircle :size="16" />
          <span>{{ error }}</span>
        </div>

        <div>
          <label class="block text-sm font-medium text-gray-400 mb-2">Email</label>
          <input
            v-model="email"
            type="email"
            class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"
            placeholder="seu@email.com"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-400 mb-2">Senha</label>
          <input
            v-model="password"
            type="password"
            class="w-full clay-input border border-white/10 rounded-xl px-4 py-3 text-white focus:outline-none"
            placeholder="••••••••"
          />
        </div>

        <button 
          type="submit"
          :disabled="isLoading"
          class="w-full justify-center clay-btn disabled:opacity-50 disabled:cursor-not-allowed py-3 px-6"
        >
          {{ isLoading ? 'Entrando...' : 'Entrar no Painel' }}
        </button>
      </form>

      <div class="mt-6 text-center">
        <router-link to="/" class="text-sm text-brand-blue hover:underline">Voltar para o site</router-link>
      </div>

      <div class="mt-8 pt-6 border-t border-white/5 text-center">
        <p class="text-xs text-gray-500">Acesso restrito</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { Lock, AlertCircle } from 'lucide-vue-next';
import { useAuth } from '../../composables/useAuth';

const router = useRouter();
const { signIn } = useAuth();

const email = ref('');
const password = ref('');
const error = ref('');
const isLoading = ref(false);

const handleLogin = async () => {
  error.value = '';
  isLoading.value = true;
  try {
    await signIn(email.value, password.value);
    router.push('/admin/dashboard');
  } catch (e) {
    error.value = e instanceof Error ? e.message : 'E-mail ou senha incorretos.';
  } finally {
    isLoading.value = false;
  }
};
</script>
