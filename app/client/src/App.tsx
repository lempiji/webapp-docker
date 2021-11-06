import React from 'react';
import logo from './logo.svg';
import './App.css';

function App() {
  const [data, setData] = React.useState<number>(0);
  React.useEffect(() => {
    const abortController = new AbortController();
    fetch("api/data", { signal: abortController.signal })
      .then(res => {
        if (res.status === 200) return res.json();
        throw new Error("Server API Error");
      })
      .then(json => {
        if (json && typeof json.value === "number")
          setData(json.value);
        else
          setData(-1);
      });
    
    return () => { abortController.abort(); };
  }, [setData]);

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Hello, vibe.d!
        </p>
        <p>
          Edit <code>app/client/src/App.tsx</code> and save to reload.
        </p>
        <p>Server API Data : {data}</p>
      </header>
    </div>
  );
}

export default App;
