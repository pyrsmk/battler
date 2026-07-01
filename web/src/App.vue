<template>
  <div class="battler-frame">
    <header class="header">
      <h1 class="title">Barcode Battler II</h1>
      <h2 class="subtitle">barcode reader</h2>
    </header>

    <div class="input-section">
      <div class="input-frame">
        <input
          v-model="barcode"
          type="text"
          inputmode="numeric"
          pattern="[0-9]*"
          placeholder="Enter barcode..."
          class="barcode-input"
          maxlength="13"
          @keyup.enter="scan"
        />
        <button class="scan-button" :disabled="loading" @click="scan">
          {{ loading ? 'SCANNING...' : 'SCAN' }}
        </button>
      </div>
    </div>

    <div class="lcd-screen">
      <div class="lcd-inner">
        <div v-if="error" class="lcd-error">
          <span class="lcd-label">ERROR</span>
          <span class="lcd-value">{{ error }}</span>
        </div>

        <div v-else-if="cardData" class="lcd-content">
          <div
            v-for="(group, groupIndex) in cardData"
            :key="groupIndex"
            class="lcd-group"
          >
            <div
              v-for="(value, label) in group"
              :key="label"
              class="lcd-row"
            >
              <span class="lcd-label">{{ label }}</span>
              <span class="lcd-value">{{ value }}</span>
            </div>
          </div>
        </div>

        <div v-else class="lcd-idle">
          <span class="lcd-idle-text">AWAITING BARCODE INPUT...</span>
        </div>
      </div>
    </div>

    <div class="ornament-bottom">
      <span class="ornament-diamond"></span>
      <span class="ornament-line"></span>
      <span class="ornament-diamond"></span>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const barcode = ref('')
const cardData = ref(null)
const error = ref(null)
const loading = ref(false)

async function scan() {
  const code = barcode.value.trim()
  if (!code) return

  loading.value = true
  error.value = null
  cardData.value = null

  try {
    const response = await fetch(`${import.meta.env.VITE_API_BASE_URL || ''}/barcode/${encodeURIComponent(code)}`)
    const data = await response.json()

    if (data.type === 'error') {
      error.value = data.message
    } else {
      cardData.value = data
      barcode.value = ''
    }
  } catch (e) {
    error.value = 'Connection failed'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.battler-frame {
  border: 3px solid var(--gold-dark);
  background: var(--bg-panel);
  padding: 2rem 1.5rem;
  box-shadow:
    0 0 30px rgba(0, 0, 0, 0.6),
    inset 0 1px 0 rgba(200, 168, 78, 0.15);
}

/* Header */
.header {
  text-align: center;
  margin-bottom: 1.5rem;
  padding-bottom: 1rem;
  border-bottom: 2px solid var(--border-ornate);
}

.title {
  font-family: 'MedievalSharp', cursive;
  font-size: 2rem;
  color: var(--gold);
  text-shadow:
    0 0 10px rgba(200, 168, 78, 0.4),
    2px 2px 0 rgba(0, 0, 0, 0.5);
  letter-spacing: 2px;
}

.subtitle {
  font-family: 'Press Start 2P', monospace;
  font-size: 0.6rem;
  color: var(--gold-dark);
  text-transform: uppercase;
  letter-spacing: 4px;
  margin-top: 0.5rem;
}

/* Input section */
.input-section {
  margin-bottom: 1.5rem;
}

.input-frame {
  display: flex;
  gap: 0.5rem;
  border: 2px solid var(--border-ornate);
  padding: 0.5rem;
  background: rgba(0, 0, 0, 0.3);
}

.barcode-input {
  flex: 1;
  background: rgba(0, 0, 0, 0.5);
  border: 1px solid var(--gold-dark);
  padding: 0.75rem 1rem;
  color: var(--gold-light);
  font-family: 'Press Start 2P', monospace;
  font-size: 0.8rem;
  outline: none;
  letter-spacing: 2px;
}

.barcode-input::placeholder {
  color: var(--gold-dark);
  font-size: 0.55rem;
}

.barcode-input:focus {
  border-color: var(--gold);
  box-shadow: 0 0 8px rgba(200, 168, 78, 0.3);
}

.scan-button {
  background: linear-gradient(180deg, var(--gold) 0%, var(--gold-dark) 100%);
  border: 1px solid var(--gold);
  padding: 0.75rem 1.25rem;
  color: var(--bg-dark);
  font-family: 'Press Start 2P', monospace;
  font-size: 0.6rem;
  cursor: pointer;
  text-transform: uppercase;
  font-weight: bold;
  transition: all 0.15s;
}

.scan-button:hover:not(:disabled) {
  background: linear-gradient(180deg, var(--gold-light) 0%, var(--gold) 100%);
  box-shadow: 0 0 12px rgba(200, 168, 78, 0.4);
}

.scan-button:active:not(:disabled) {
  transform: scale(0.97);
}

.scan-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

/* LCD screen */
.lcd-screen {
  border: 3px solid var(--border-ornate);
  background: var(--bg-lcd);
  padding: 3px;
  box-shadow:
    inset 0 2px 8px rgba(0, 0, 0, 0.6),
    0 1px 0 rgba(200, 168, 78, 0.1);
}

.lcd-inner {
  border: 1px solid rgba(90, 255, 58, 0.15);
  padding: 1rem;
  min-height: 180px;
  background:
    repeating-linear-gradient(
      0deg,
      transparent,
      transparent 1px,
      rgba(0, 0, 0, 0.12) 1px,
      rgba(0, 0, 0, 0.12) 3px
    ),
    var(--bg-lcd);
}

.lcd-content, .lcd-error, .lcd-idle {
  font-family: 'Press Start 2P', monospace;
}

/* LCD groups */
.lcd-group {
  padding: 0.5rem 0;
}

.lcd-group + .lcd-group {
  border-top: 1px dashed var(--lcd-dim);
}

.lcd-row {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  padding: 0.3rem 0;
  gap: 0.5rem;
}

.lcd-label {
  color: var(--lcd-dim);
  font-size: 0.5rem;
  text-transform: uppercase;
  flex-shrink: 0;
}

.lcd-value {
  color: var(--lcd-text);
  font-size: 0.6rem;
  text-align: right;
  text-shadow: 0 0 6px rgba(90, 255, 58, 0.5);
  word-break: break-all;
}

/* Error */
.lcd-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 150px;
  gap: 0.75rem;
}

.lcd-error .lcd-label {
  color: var(--error-red);
  font-size: 0.7rem;
  text-shadow: 0 0 8px rgba(255, 68, 68, 0.5);
}

.lcd-error .lcd-value {
  color: var(--error-red);
  font-size: 0.5rem;
  text-shadow: 0 0 6px rgba(255, 68, 68, 0.4);
  text-align: center;
}

/* Idle state */
.lcd-idle {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 150px;
}

.lcd-idle-text {
  color: var(--lcd-dim);
  font-size: 0.5rem;
  animation: blink 1.5s ease-in-out infinite;
}

@keyframes blink {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.3; }
}

/* Bottom ornament */
.ornament-bottom {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 1.5rem;
  gap: 0.5rem;
}

.ornament-line {
  flex: 1;
  height: 1px;
  background: linear-gradient(90deg, transparent, var(--gold-dark), transparent);
}

.ornament-diamond {
  width: 8px;
  height: 8px;
  background: var(--gold-dark);
  transform: rotate(45deg);
}
</style>
