<template>
  <section id="courses" class="py-20 md:py-28 px-4 md:px-8 relative overflow-hidden bg-brand-dark">
    <div class="max-w-7xl mx-auto w-full">
      <div class="flex flex-col md:flex-row justify-between items-end mb-12 gap-4">
        <div class="max-w-2xl">
          <h2 class="text-4xl md:text-5xl font-black mb-4 uppercase italic">
            Nossos <span class="text-brand-gold">Cursos Especializados</span>
          </h2>
          <p class="text-gray-400 font-medium tracking-wide">
            Treinamento de elite para motoristas com as melhores certificações do mercado.
          </p>
        </div>
        <button 
          v-if="courses.length > visibleCount"
          @click="toggleShowAll"
          class="clay-btn shrink-0 px-8 py-3 rounded-full text-sm font-black uppercase tracking-wide"
        >
          {{ showAll ? 'Ver Menos' : 'Ver Grade Completa' }}
        </button>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <div
          v-for="course in displayedCourses"
          :key="course.id"
          class="group relative clay-card overflow-hidden transition-all duration-300 card-glow"
        >
          <div class="h-56 overflow-hidden relative">
            <div 
              class="absolute top-4 left-4 py-1 px-3 rounded-full glass text-xs font-bold uppercase tracking-wider"
              :class="textColor(course.accentColor)"
            >
              {{ course.category }}
            </div>
            <img
              :src="course.imageUrl"
              :alt="course.title"
              loading="lazy"
              class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
            />
          </div>

          <div class="p-8 relative z-10">
            <h3 class="text-2xl font-bold mb-3 text-white group-hover:text-brand-gold transition-colors font-black italic uppercase tracking-tighter">
              {{ course.title }}
            </h3>
            <p class="text-gray-400 text-sm mb-4 line-clamp-3 font-medium">
              {{ course.description }}
            </p>

            <div class="flex gap-3 mb-6">
              <button
                @click="openDetailsModal(course)"
                class="flex-1 py-3 rounded-xl border border-brand-gold/30 text-brand-gold hover:bg-brand-gold/10 transition-all text-sm font-bold uppercase tracking-wide"
              >
                Ver Detalhes
              </button>
              <button
                @click="handleBuyClick(course.title)"
                class="clay-btn flex-1 py-3 flex items-center justify-center gap-2"
              >
                <MessageCircle :size="18" />
                <span class="hidden sm:inline">WhatsApp</span>
              </button>
            </div>
          </div>

          <div 
            class="h-1 w-0 group-hover:w-full transition-all duration-500"
            :class="bgColor(course.accentColor)"
          />
        </div>
      </div>

      <div v-if="courses.length > visibleCount" class="flex justify-center mt-12">
        <button 
          @click="toggleShowAll"
          class="clay-btn px-12 py-4 text-base font-black uppercase tracking-wide"
        >
          {{ showAll ? 'Ver Menos Cursos' : `Ver Todos os ${courses.length} Cursos` }}
        </button>
      </div>
    </div>

    <!-- Modal de Detalhes do Curso -->
    <Transition name="modal">
      <div v-if="showDetailsModal" class="fixed inset-0 bg-black/70 backdrop-blur-sm flex items-center justify-center z-50 p-4" @click.self="closeDetailsModal">
        <div class="clay-card w-full max-w-2xl max-h-[90vh] overflow-y-auto">
          <div class="relative">
            <img
              :src="selectedCourse?.imageUrl"
              :alt="selectedCourse?.title"
              class="w-full h-64 object-cover"
            />
            <button 
              @click="closeDetailsModal"
              class="absolute top-4 right-4 w-10 h-10 rounded-full bg-black/50 backdrop-blur-sm flex items-center justify-center text-white hover:bg-brand-gold hover:text-black transition-all"
            >
              <X :size="20" />
            </button>
            <div 
              class="absolute bottom-4 left-4 py-2 px-4 rounded-full glass text-sm font-bold uppercase tracking-wider"
              :class="textColor(selectedCourse?.accentColor || 'yellow')"
            >
              {{ selectedCourse?.category }}
            </div>
          </div>

          <div class="p-8">
            <h2 class="text-3xl font-black italic uppercase tracking-tighter text-white mb-4">
              {{ selectedCourse?.title }}
            </h2>

            <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
              <div class="clay-light p-4 rounded-xl text-center">
                <Clock :size="24" class="mx-auto mb-2 text-brand-gold" />
                <p class="text-xs text-gray-400 uppercase">Carga Horária</p>
                <p class="text-lg font-bold text-white">40 Horas</p>
              </div>
              <div class="clay-light p-4 rounded-xl text-center">
                <BookOpen :size="24" class="mx-auto mb-2 text-brand-gold" />
                <p class="text-xs text-gray-400 uppercase">Módulos</p>
                <p class="text-lg font-bold text-white">8</p>
              </div>
              <div class="clay-light p-4 rounded-xl text-center">
                <Award :size="24" class="mx-auto mb-2 text-brand-gold" />
                <p class="text-xs text-gray-400 uppercase">Certificado</p>
                <p class="text-lg font-bold text-white">Sim</p>
              </div>
              <div class="clay-light p-4 rounded-xl text-center">
                <GraduationCap :size="24" class="mx-auto mb-2 text-brand-gold" />
                <p class="text-xs text-gray-400 uppercase">Modalidade</p>
                <p class="text-lg font-bold text-white">Presencial</p>
              </div>
            </div>

            <div class="mb-8">
              <h3 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
                <FileText :size="20" class="text-brand-gold" />
                Descrição Completa
              </h3>
              <p class="text-gray-300 leading-relaxed">
                {{ selectedCourse?.description }}
              </p>
            </div>

            <div class="mb-8">
              <h3 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
                <ListChecks :size="20" class="text-brand-gold" />
                O que você vai aprender
              </h3>
              <ul class="space-y-3">
                <li v-for="(item, index) in courseModules" :key="index" class="flex items-start gap-3 text-gray-300">
                  <CheckCircle :size="18" class="text-brand-gold mt-0.5 shrink-0" />
                  <span>{{ item }}</span>
                </li>
              </ul>
            </div>

            <div class="mb-8">
              <h3 class="text-xl font-bold text-white mb-4 flex items-center gap-2">
                <Target :size="20" class="text-brand-gold" />
                Requisitos
              </h3>
              <ul class="space-y-2 text-gray-300">
                <li class="flex items-center gap-2">
                  <Check :size="16" class="text-brand-gold" />
                  Ter CPF regularizado
                </li>
                <li class="flex items-center gap-2">
                  <Check :size="16" class="text-brand-gold" />
                  Idade mínima de 18 anos
                </li>
                <li class="flex items-center gap-2">
                  <Check :size="16" class="text-brand-gold" />
                  CNH categoria B ou superior (para alguns cursos)
                </li>
              </ul>
            </div>

            <div class="flex flex-col sm:flex-row gap-4">
              <button
                @click="handleBuyClick(selectedCourse?.title || '')"
                class="clay-btn flex-1 py-4 flex items-center justify-center gap-3 text-lg font-bold uppercase"
              >
                <MessageCircle :size="22" />
                Quero Me Inscrever
              </button>
              <a 
                href="tel:+5569999999999"
                class="flex-1 py-4 rounded-2xl border border-brand-gold/30 text-brand-gold hover:bg-brand-gold/10 transition-all flex items-center justify-center gap-3 text-lg font-bold uppercase"
              >
                <Phone :size="22" />
                Ligar Agora
              </a>
            </div>

            <p class="text-center text-sm text-gray-500 mt-6">
              Turmas com vagas limitadas. Garanta sua lugar!
            </p>
          </div>
        </div>
      </div>
    </Transition>
  </section>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import { MessageCircle, X, Clock, BookOpen, Award, GraduationCap, FileText, ListChecks, Target, CheckCircle, Check, Phone } from 'lucide-vue-next';
import { useContent } from '../../composables/useContent';
import type { Course } from '../../types';

const { courses, contactInfo } = useContent();

const showAll = ref(false);
const visibleCount = 6;
const showDetailsModal = ref(false);
const selectedCourse = ref<Course | null>(null);

const courseModules = [
  'Fundamentos da direção defensiva e preventiva',
  'Legislação de trânsito e normas regulamentadoras',
  'Manutenção básica e prevenção de falhas mecânicas',
  'Gestão de tempo e rotaslogísticas',
  'Atendimento ao cliente e comunicação profissional',
  'Segurança na carga e transporte de mercadorias',
  'Tecnologias e aplicativos para motoristas',
  'Preparação para o mercado de trabalho'
];

const displayedCourses = computed(() => {
  if (showAll.value || courses.value.length <= visibleCount) {
    return courses.value;
  }
  return courses.value.slice(0, visibleCount);
});

const toggleShowAll = () => {
  showAll.value = !showAll.value;
};

const openDetailsModal = (course: Course) => {
  selectedCourse.value = course;
  showDetailsModal.value = true;
  document.body.style.overflow = 'hidden';
};

const closeDetailsModal = () => {
  showDetailsModal.value = false;
  selectedCourse.value = null;
  document.body.style.overflow = '';
};

const colorMap: Record<string, { text: string; bg: string }> = {
  yellow: { text: 'text-brand-gold', bg: 'bg-brand-gold' },
  gold: { text: 'text-brand-gold', bg: 'bg-brand-gold' },
  green: { text: 'text-brand-green', bg: 'bg-brand-green' },
  blue: { text: 'text-brand-blue', bg: 'bg-brand-blue' },
};

const textColor = (color: string) => {
  const colors = colorMap[color] || colorMap.gold;
  return colors.text;
};

const bgColor = (color: string) => {
  const colors = colorMap[color] || colorMap.gold;
  return colors.bg;
};

const handleBuyClick = (courseTitle: string) => {
  const cleanNumber = contactInfo.value.whatsappNumber.replace(/\D/g, '');
  const message = `Olá! Tenho interesse no curso: *${courseTitle}*. Poderia me dar mais informações sobre vagas e horários?`;
  const url = `https://wa.me/${cleanNumber}?text=${encodeURIComponent(message)}`;
  window.open(url, '_blank');
};
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: all 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .clay-card,
.modal-leave-to .clay-card {
  transform: scale(0.95) translateY(20px);
}

.clay-card {
  transition: transform 0.3s ease;
}
</style>
