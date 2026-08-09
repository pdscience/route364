<template>
  <div class="min-h-screen flex bg-brand-dark text-white">
    <aside class="w-64 fixed h-full clay z-20 hidden md:flex flex-col">
      <div class="p-6 border-b border-white/5">
        <div class="flex items-center gap-3">
          <div class="relative w-10 h-10 flex items-center justify-center">
            <img src="/logo_route364.jpg" alt="Route 364 Logo" loading="lazy" class="w-full h-full object-contain rounded-full border border-brand-gold/20 p-0.5 bg-white" />
          </div>
          <div class="flex flex-col">
            <span class="font-black text-lg tracking-wide text-white leading-none italic uppercase">
              ROUTE <span class="text-brand-gold">364</span>
            </span>
            <span class="text-[0.55rem] font-bold text-gray-400 uppercase tracking-[0.05em] leading-tight">
              Admin Panel
            </span>
          </div>
        </div>
      </div>

      <nav class="flex-1 p-4 space-y-2">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="flex items-center gap-3 px-4 py-3 rounded-xl transition-all duration-200"
          :class="$route.path === item.path ? 'clay-btn text-white' : 'text-gray-400 hover:bg-white/5 hover:text-white'"
        >
          <component :is="item.icon" :size="20" />
          <span>{{ item.label }}</span>
        </router-link>
      </nav>

      <div class="p-4 border-t border-white/5 space-y-2">
        <router-link to="/" class="flex items-center gap-3 px-4 py-3 rounded-xl text-gray-400 hover:text-brand-gold transition-all">
          <Home :size="20" />
          <span>Ver Site</span>
        </router-link>
        <button
          @click="handleLogout"
          class="w-full flex items-center gap-3 px-4 py-3 rounded-xl text-red-400 hover:text-red-300 transition-all"
        >
          <LogOut :size="20" />
          <span>Sair</span>
        </button>
      </div>
    </aside>

    <main class="flex-1 md:ml-64 p-8 overflow-y-auto">
      <div class="max-w-5xl mx-auto">
        <slot></slot>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import { LayoutDashboard, BookOpen, Users, LogOut, Home, Info, MessageSquare } from 'lucide-vue-next';
import { useAuth } from '../../composables/useAuth';

const router = useRouter();
const { signOut } = useAuth();

const navItems = [
  { icon: LayoutDashboard, label: 'Dashboard', path: '/admin/dashboard' },
  { icon: BookOpen, label: 'Gerenciar Cursos', path: '/admin/courses' },
  { icon: Users, label: 'Depoimentos', path: '/admin/testimonials' },
  { icon: Info, label: 'Sobre Nós', path: '/admin/about' },
  { icon: MessageSquare, label: 'Contato', path: '/admin/contact' },
];

const handleLogout = async () => {
  await signOut();
  router.push('/');
};
</script>
