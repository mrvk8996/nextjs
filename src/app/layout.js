import './globals.css';
import Header from '../components/Header';
import Footer from '../components/Footer';
import { GlobalProvider } from '@/context/GlobalContext';

export const metadata = {
  title: 'Hello World Next Page',
  description: 'Next.js hello world example with header and footer',
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {/* ✅ GlobalProvider MUST wrap everything */}
        <GlobalProvider>
          <Header />
          <main className="main-content">{children}</main>
          <Footer />
        </GlobalProvider>
      </body>
    </html>
  );
}
