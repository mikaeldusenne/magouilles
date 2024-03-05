
<template>
  <div class="services-container">
    <ServiceIcon
      v-for="service in services"
      :key="service.name"
      :name="service.name"
      :description="service.description"
      :icon="service.icon"
      :link="service.link"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import ServiceIcon from './components/ServiceIcon.vue';

/* components: {
 *   ServiceIcon,
 * }, */
const services = ref([
  {
    name: 'Jupyter',
    description: 'Calcul interactif et cahiers de notes.',
    link: 'jupyter',
  },
  {
    name: 'GitLab',
    description: 'Plateforme DevOps pour vos projets.',
    link: 'gitlab',
  },
  {
    name: 'Element',
    description: 'Messagerie sécurisée et collaboration.',
    link: 'chat',
  },
  {
    name: 'Jitsi',
    description: 'Conférences vidéo sécurisées et open source.',
    link: 'meet',
  },
  {
    name: 'Owncloud',
    description: 'Stockage et synchronisation de fichiers haute performance.',
    link: 'drive',
  },
  {
    name: 'Draw.io',
    description: 'Outil de diagrammes en ligne gratuit et open source.',
    link: 'drawio',
  },
])

</script>

<style >
.logo {
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
body, html {
  margin: 0;
  padding: 0;
  font-family: Arial, sans-serif;
}
#app {
  /* display: flex;
     justify-content: center;
     align-items: center; */
  /* padding: 20px; */
  width: 80%;
  box-sizing: border-box;
}
.services-container {
  display: grid;
  grid-template-columns: 25% 25% 25% 25%;
  justify-items: stretch;
  align-items: top;

  column-gap: 2rem;
  row-gap: 2rem;
  width: 100%; /* Ensures the container does not overflow the viewport */
  /* overflow-y: auto; /* Allows scrolling on overflow */
}

@media (max-width: 768px) {
  .services-container {
    grid-template-columns: 50% 50%;
  }
}

@media (max-width: 480px) {
  .services-container {
    grid-template-columns: 100%;
  }
}
</style>
