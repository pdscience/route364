<template>
  <section id="testimonials" class="py-20 md:py-28 px-4 md:px-8 relative overflow-hidden bg-brand-dark">
    <div class="absolute top-10 left-0 w-full overflow-hidden pointer-events-none opacity-[0.03]">
      <h2 class="text-[15vw] font-black text-white whitespace-nowrap text-center">FEEDBACK</h2>
    </div>

    <div class="max-w-7xl mx-auto relative z-10">
      <div class="mb-12 text-center">
        <h2 class="text-4xl md:text-5xl font-black mb-4 uppercase italic tracking-tighter">O que dizem nossos alunos</h2>
        <div class="w-24 h-2 bg-brand-gold mx-auto rounded-full"></div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div
          v-for="(testimonial, index) in visibleTestimonials"
          :key="testimonial.id || index"
          class="clay-card p-8 relative"
        >
          <Quote class="absolute top-6 right-6 text-brand-gold/10 w-12 h-12" />
          
          <div class="flex justify-center mb-4 gap-1">
            <Star v-for="i in 5" :key="i" :size="18" class="fill-brand-gold text-brand-gold" />
          </div>

          <p class="text-base text-gray-300 mb-6 italic leading-relaxed line-clamp-4">
            "{{ testimonial.content }}"
          </p>

          <div class="flex flex-col items-center gap-3">
            <img
              :src="testimonial.avatarUrl"
              :alt="`Foto de ${testimonial.name}`"
              loading="lazy"
              class="w-16 h-16 rounded-full border-4 border-brand-gold/30 object-cover"
            />
            <div class="text-center">
              <h4 class="text-lg font-bold text-white uppercase tracking-wide">{{ testimonial.name }}</h4>
              <p class="text-sm text-brand-gold font-bold">{{ testimonial.role }}</p>
            </div>
          </div>
        </div>
      </div>

      <div class="flex justify-center items-center gap-4 mt-12">
        <button 
          @click="prev" 
          :disabled="currentPage === 0"
          class="clay-card p-4 text-white transition-all hover:scale-110 disabled:opacity-30 disabled:hover:scale-100"
          :class="currentPage === 0 ? 'cursor-not-allowed' : 'hover:text-brand-gold'"
        >
          <ChevronLeft :size="24" />
        </button>
        
        <div class="flex gap-2">
          <button
            v-for="i in totalPages"
            :key="i"
            @click="goToPage(i - 1)"
            class="w-10 h-10 rounded-full transition-all text-sm font-bold"
            :class="currentPage === i - 1 
              ? 'clay-btn' 
              : 'text-gray-400 hover:text-brand-gold'"
          >
            {{ i }}
          </button>
        </div>
        
        <button 
          @click="next" 
          :disabled="currentPage >= totalPages - 1"
          class="clay-btn p-4 transition-all hover:scale-110 disabled:opacity-30 disabled:hover:scale-100"
        >
          <ChevronRight :size="24" />
        </button>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { ChevronLeft, ChevronRight, Star, Quote } from 'lucide-vue-next';
import { useContent } from '../../composables/useContent';

const { testimonials } = useContent();
const currentPage = ref(0);
const itemsPerPage = 6;

const totalPages = computed(() => Math.ceil(testimonials.value.length / itemsPerPage));

const visibleTestimonials = computed(() => {
  const start = currentPage.value * itemsPerPage;
  return testimonials.value.slice(start, start + itemsPerPage);
});

const next = () => {
  if (currentPage.value < totalPages.value - 1) {
    currentPage.value++;
  }
};

const prev = () => {
  if (currentPage.value > 0) {
    currentPage.value--;
  }
};

const goToPage = (page: number) => {
  currentPage.value = page;
};
</script>
