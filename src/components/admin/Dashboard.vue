<template>
  <AdminLayout>
    <h1 class="text-3xl font-bold mb-8">Dashboard</h1>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <div v-for="stat in stats" :key="stat.label" class="clay-card p-6">
        <div class="flex items-center justify-between mb-4">
          <div :class="`p-3 rounded-xl ${stat.bg}`">
            <component :is="stat.icon" :size="24" :class="stat.color" />
          </div>
          <span class="text-2xl font-bold text-white">{{ stat.value }}</span>
        </div>
        <h3 class="text-gray-400 font-medium">{{ stat.label }}</h3>
      </div>
    </div>

    <div class="clay-card p-8">
      <h2 class="text-xl font-bold mb-4">Bem-vindo ao Route 364 Admin</h2>
      <p class="text-gray-400">
        Utilize o menu lateral para gerenciar o conteúdo do site. As alterações feitas aqui são refletidas em tempo real na página principal.
      </p>
    </div>
  </AdminLayout>
</template>

<script setup lang="ts">
import { computed } from 'vue';
import { BookOpen, Users, TrendingUp } from 'lucide-vue-next';
import AdminLayout from './AdminLayout.vue';
import { useContent } from '../../composables/useContent';

const { courses, testimonials } = useContent();

const stats = computed(() => [
  { label: 'Cursos Ativos', value: courses.value.length, icon: BookOpen, color: 'text-brand-blue', bg: 'bg-brand-blue/10' },
  { label: 'Depoimentos', value: testimonials.value.length, icon: Users, color: 'text-brand-gold', bg: 'bg-brand-gold/10' },
  { label: 'Alunos Totais', value: '+5,000', icon: TrendingUp, color: 'text-brand-green', bg: 'bg-brand-green/10' },
]);
</script>
