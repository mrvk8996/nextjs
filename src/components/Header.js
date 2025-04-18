'use client';
import { useGlobalContext } from '../context/GlobalContext.js';

export default function Header() {
  const { selectedNews } = useGlobalContext();

  return (
    <header className="site-header">
      <h1>Header</h1>
      {selectedNews.length > 0 && (
      <div className="selected-info">
        Selected: {selectedNews.length}
        
          <ul className="selected-list">
            {selectedNews.map((news) => (
              <li key={news.id}>{news.title}</li>
            ))}
          </ul>
        
      </div>
      )}
    </header>
  );
}
