'use client';
import { createContext, useContext, useState } from 'react';

const GlobalContext = createContext();

export function GlobalProvider({ children }) {
  const [count, setCount] = useState(0);
  const [selectedNews, setSelectedNews] = useState([]);

  const toggleNewsItem = (item) => {
    setSelectedNews(prev => {
      const exists = prev.find(news => news.id === item.id);
      if (exists) return prev.filter(news => news.id !== item.id);
      return [...prev, item];
    });
  };

  return (
    <GlobalContext.Provider value={{
      count,
      increment: () => setCount(c => c + 1),
      decrement: () => setCount(c => c - 1),
      selectedNews,
      toggleNewsItem,
    }}>
      {children}
    </GlobalContext.Provider>
  );
}

export const useGlobalContext = () => useContext(GlobalContext);
