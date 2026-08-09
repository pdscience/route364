<template>
  <header :class="['fixed top-0 left-0 w-full z-50 transition-all duration-300', navBackground]">
    <div class="max-w-7xl mx-auto px-4 md:px-8">
      <div class="flex items-center justify-between h-24">
        <a href="#" class="flex items-center gap-4 group">
          <div class="relative w-16 h-16 md:w-20 md:h-20 flex items-center justify-center">
            <img src="/logo_route364.jpg" alt="Route 364 Logo" loading="lazy" class="w-full h-full object-contain rounded-full border border-brand-gold/20 p-1 bg-white" />
          </div>
          <div class="hidden sm:flex flex-col">
            <span class="font-black text-2xl md:text-3xl tracking-tighter text-white leading-none italic uppercase">
              ROUTE <span class="text-brand-gold">364</span>
            </span>
            <span class="text-[0.6rem] md:text-[0.7rem] font-black text-brand-gold uppercase tracking-[0.2em] leading-tight">
              Formação Profissional | Soluções Financeiras
            </span>
          </div>
        </a>

        <nav class="hidden md:flex items-center gap-8">
          <a
            v-for="item in NAV_ITEMS"
            :key="item.label"
            :href="item.href"
            class="text-gray-300 hover:text-brand-gold transition-colors text-xs font-black uppercase tracking-widest"
          >
            {{ item.label }}
          </a>
          <button 
            @click="scrollToCourses"
            class="clay-btn px-8 py-3 text-xs font-black uppercase tracking-widest"
          >
            Matricule-se
          </button>
        </nav>

        <button
          class="md:hidden text-white hover:text-brand-gold transition-colors"
          @click="toggleMobileMenu"
        >
          <X v-if="isMobileMenuOpen" :size="24" />
          <Menu v-else :size="24" />
        </button>
      </div>
    </div>

    <Transition name="slide">
      <div v-if="isMobileMenuOpen" class="md:hidden glass border-b border-white/5 overflow-hidden">
        <div class="flex flex-col p-4 space-y-4">
          <a
            v-for="item in NAV_ITEMS"
            :key="item.label"
            :href="item.href"
            class="text-gray-300 hover:text-brand-gold block py-2 text-center font-black uppercase tracking-widest text-sm"
            @click="closeMobileMenu"
          >
            {{ item.label }}
          </a>
          <div class="flex justify-center pt-2">
            <button 
              @click="scrollToCourses"
              class="clay-btn w-full py-3 px-6"
            >
              Matricule-se
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </header>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { Menu, X } from 'lucide-vue-next';
import { NAV_ITEMS } from '../../constants';

const isScrolled = ref(false);
const isMobileMenuOpen = ref(false);
const ticking = ref(false);

const navBackground = computed(() => {
  return isScrolled.value
    ? "glass"
    : "bg-transparent";
});

const handleScroll = () => {
  if (!ticking.value) {
    window.requestAnimationFrame(() => {
      isScrolled.value = window.scrollY > 20;
      ticking.value = false;
    });
    ticking.value = true;
  }
};

const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value;
};

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false;
};

const scrollToCourses = () => {
  isMobileMenuOpen.value = false;
  document.getElementById('courses')?.scrollIntoView({ behavior: 'smooth' });
};

onMounted(() => {
  isScrolled.value = window.scrollY > 20;
  window.addEventListener('scroll', handleScroll, { passive: true });
});

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll);
});
</script>

<style scoped>
.slide-enter-active,
.slide-leave-active {
  transition: all 0.3s ease;
}

.slide-enter-from,
.slide-leave-to {
  opacity: 0;
  max-height: 0;
}

.slide-enter-to,
.slide-leave-from {
  opacity: 1;
  max-height: 300px;
}
</style>
