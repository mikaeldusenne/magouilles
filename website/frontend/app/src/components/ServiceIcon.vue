<template>
  <div class="service" @click="openService(href)">
    <!-- <img :src="icon" :alt="name" class="icon"> -->
    <img :src="iconsrc" :alt="name" class="icon">
    <h2>{{ name }}</h2>
    <p>{{ description }}</p>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { defineProps } from 'vue'

const props = defineProps({
  name: String,
  description: String,
  link: String,
})

function openService(url) {
  window.open(url, '_blank');
}

const href = computed(() => {
  return `https://${props.link}.${import.meta.env.VITE_EDS_DOMAIN}`
})

const iconsrc = computed(() => {
  return `/${props.link}.jpg`
})

</script>

<style scoped>
.service {
  background: #eee;
  padding: 1rem;
  
  cursor: pointer;
  text-align: center;
  min-width: 25%;
  max-width: 100%;
}
.icon {
  border: 2px solid #ddd;
  max-height: 10rem;
  width: auto;
  aspect-ratio: 1/1 !important;
  max-width: 100%;
}
.service {
  display: flex;
  flex-direction: column;
  align-items: center;
  align-content: center;
}

@media (max-width: 768px) {
  .service {
  }
}


.service-info {
  text-align: center;
}

</style>

