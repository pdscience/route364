<template>
  <section id="about" class="py-20 md:py-28 px-4 md:px-8 relative overflow-hidden bg-brand-dark">
    <div class="max-w-7xl mx-auto w-full">
      <div class="text-center max-w-3xl mx-auto mb-16">
        <h2 class="text-4xl md:text-5xl font-black mb-4 uppercase italic tracking-tighter">
          {{ aboutData.titlePrefix }} <span class="text-brand-gold">{{ aboutData.titleHighlight }}</span>{{ aboutData.titleSuffix }}
        </h2>
        <p class="text-gray-400 text-lg">
          {{ aboutData.description }}
        </p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
        <div
          v-for="feature in features"
          :key="feature.id"
          class="group clay-card p-8 transition-all duration-300 hover:-translate-y-2 card-glow"
        >
          <div 
            class="w-14 h-14 rounded-xl glass flex items-center justify-center mb-6 transition-all duration-300"
            :class="iconColorClasses(feature.color)"
          >
            <component :is="getIcon(feature.icon)" :size="28" class="text-gray-300 transition-colors duration-300 group-hover:text-inherit" />
          </div>
          <h3 class="text-xl font-bold mb-3 text-white group-hover:text-white transition-colors">
            {{ feature.title }}
          </h3>
          <p class="text-gray-400 text-sm leading-relaxed">
            {{ feature.description }}
          </p>
        </div>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { Monitor, Award, Users, Clock } from 'lucide-vue-next';
import { useContent } from '../../composables/useContent';

const { features, aboutData } = useContent();

const iconMap: Record<string, any> = {
  monitor: Monitor,
  award: Award,
  users: Users,
  clock: Clock,
};

const getIcon = (icon: string) => {
  return iconMap[icon] || Monitor;
};


const iconColorClasses = (color: string) => {
  const classes: Record<string, string> = {
    yellow: "group-hover:bg-brand-gold/10 group-hover:text-brand-gold group-hover:border-brand-gold/50",
    gold: "group-hover:bg-brand-gold/10 group-hover:text-brand-gold group-hover:border-brand-gold/50",
    green: "group-hover:bg-brand-green/10 group-hover:text-brand-green group-hover:border-brand-green/50",
    blue: "group-hover:bg-brand-blue/10 group-hover:text-brand-blue group-hover:border-brand-blue/50",
  };
  return classes[color] || classes.gold;
};
</script>
