<template>
  <div class="min-h-screen bg-gray-50 p-4">
    <div class="max-w-3xl mx-auto">
      <h1 class="text-2xl font-bold mb-4 text-center">Busca de Operadoras - ANS</h1>

      <input
        v-model="termoBusca"
        @keyup.enter="buscarOperadoras"
        placeholder="Digite um termo (ex: odontologia)"
        class="w-full p-2 border border-gray-300 rounded mb-4"
      />

      <button
        @click="buscarOperadoras"
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
      >
        Buscar
      </button>

      <div v-if="loading" class="mt-4 text-gray-600">Carregando...</div>

      <div v-if="resultados.length" class="mt-4">
        <h2 class="text-lg font-semibold mb-2">Resultados:</h2>
        <div
          v-for="(item, index) in resultados"
          :key="index"
          class="border rounded p-3 mb-3 bg-white shadow"
        >
          <p><strong>Nome Fantasia:</strong> {{ item["Nome_Fantasia"] || 'N/A' }}</p>
          <p><strong>Razão Social:</strong> {{ item["Razao_Social"] || 'N/A' }}</p>
          <p><strong>Modalidade:</strong> {{ item["Modalidade"] || 'N/A' }}</p>
          <p><strong>UF:</strong> {{ item["UF"] || 'N/A' }}</p>
          <p><strong>Representante:</strong> {{ item["Representante"] || 'N/A' }}</p>

        </div>
      </div>

      <div v-if="!loading && resultados.length === 0 && pesquisado" class="mt-4 text-red-500">
        Nenhum resultado encontrado.
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'

const termoBusca = ref('')
const resultados = ref([])
const loading = ref(false)
const pesquisado = ref(false)

const buscarOperadoras = async () => {
  if (!termoBusca.value.trim()) return
  loading.value = true
  pesquisado.value = true
  resultados.value = []

  try {
    const res = await axios.get(`http://localhost:5000/Relatorio_cadop?q=${encodeURIComponent(termoBusca.value)}`)
    resultados.value = res.data
  } catch (err) {
    console.error('Erro ao buscar operadoras:', err)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
body {
  font-family: sans-serif;
}
</style>

