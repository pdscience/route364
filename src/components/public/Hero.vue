<template>
  <section id="home" class="relative min-h-[90vh] flex items-center pt-20 overflow-hidden bg-brand-dark">
    <div class="absolute inset-0 z-0">
      <div class="absolute inset-0 bg-gradient-to-r from-brand-dark via-brand-dark/80 to-transparent z-10" />
      <img
        src="/hero_transport_bg_1769227729242.png"
        alt="Route 364 Highway"
        loading="eager"
        class="w-full h-full object-cover opacity-60"
      />
    </div>

    <div class="max-w-7xl mx-auto px-4 md:px-8 w-full grid grid-cols-1 md:grid-cols-2 gap-12 items-center relative z-20">
      <div class="space-y-8 text-center md:text-left" ref="contentRef">
        <div class="clay-card inline-flex items-center gap-2 px-4 py-2">
          <span class="w-2 h-2 rounded-full bg-brand-gold animate-pulse"></span>
          <span class="text-sm text-brand-gold font-bold tracking-wide uppercase">Matrículas Abertas 2026</span>
        </div>

        <h1 class="text-5xl md:text-6xl font-black leading-tight tracking-tighter uppercase italic">
          Seu Futuro em <br />
          <span class="text-transparent bg-clip-text bg-gradient-to-r from-brand-gold to-yellow-500">Movimento</span>
        </h1>

        <p class="text-lg md:text-xl text-gray-300 max-w-xl mx-auto md:mx-0 leading-relaxed font-medium">
          Formação profissional especializada para motoristas que movem o Brasil. Conquiste sua certificação com a maior referência da BR-364.
        </p>

        <div class="flex flex-col sm:flex-row items-center justify-center md:justify-start gap-4">
          <button 
            @click="scrollToCourses"
            class="clay-btn px-10 py-4 text-lg font-bold uppercase flex items-center gap-2"
          >
            Ver Cursos Disponíveis
            <ArrowRight :size="18" />
          </button>
          <button class="clay-card flex items-center gap-2 text-white hover:text-brand-gold transition-colors px-6 py-3 font-bold uppercase tracking-widest text-sm">
            <PlayCircle class="text-brand-gold" :size="20" />
            <span>Conhecer Unidades</span>
          </button>
        </div>

        <div class="pt-8 flex items-center justify-center md:justify-start gap-8 text-gray-400 text-sm font-bold uppercase tracking-widest">
          <div class="flex items-center gap-2">
            <span class="text-3xl font-black text-brand-gold"></span>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ArrowRight, PlayCircle } from 'lucide-vue-next';

const scrollToCourses = () => {
  document.getElementById('courses')?.scrollIntoView({ behavior: 'smooth' });
};
</script>
