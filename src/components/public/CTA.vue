<template>
  <section class="py-20 px-4 md:px-8 bg-brand-dark">
    <div class="max-w-7xl mx-auto">
      <div class="clay-card p-12 md:p-24 text-center relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-full overflow-hidden pointer-events-none">
          <div class="absolute top-0 left-1/4 w-64 h-64 bg-brand-gold/20 blur-[100px] rounded-full mix-blend-screen"></div>
          <div class="absolute bottom-0 right-1/4 w-64 h-64 bg-brand-gold/10 blur-[100px] rounded-full mix-blend-screen"></div>
        </div>

        <div class="relative z-10 max-w-3xl mx-auto">
          <h2 class="text-4xl md:text-6xl font-black mb-6 text-white uppercase italic tracking-tighter leading-tight">
            Assuma o Volante da sua Carreira
          </h2>
          <p class="text-lg md:text-xl text-gray-300 mb-10 font-medium">
            Junte-se a milhares de motoristas profissionais que já se especializaram com a Route 364. A porta de entrada para as melhores transportadoras do país.
          </p>
          <div class="flex justify-center">
            <button
              @click="scrollToCourses"
              class="clay-btn px-12 py-5 text-xl font-black uppercase tracking-widest"
            >
              Iniciar Formação
            </button>
          </div>
          <p class="mt-8 text-sm text-gray-500 font-bold uppercase tracking-widest">
            Cursos homologados e certificados válidos
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
const scrollToCourses = () => {
  document.getElementById('courses')?.scrollIntoView({ behavior: 'smooth' });
};
</script>
