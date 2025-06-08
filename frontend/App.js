import React, { useState } from 'react';

function App() {
  const [result, setResult] = useState('');

  const spin = async () => {
    const res = await fetch('/api', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ query: '{ spinRoulette }' })
    });
    const json = await res.json();
    setResult(json.data.spinRoulette);
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>🎲 Roulette Game</h1>
      <button onClick={spin}>Spin</button>
      <p>{result}</p>
    </div>
  );
}

export default App;
