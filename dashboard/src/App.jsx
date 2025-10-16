import { Outlet } from 'react-router-dom';
import './App.css';
import Navbar from './page/Navbar';
import Footer from './page/Footer';
import { AuthProvider } from './context/AuthContext';
import { useEffect, useState } from 'react';
// import Loading from './components/Loading';

function App() {
  const [loading, setLoading] = useState(true);

  // useEffect(() => {
  //   const timer = setTimeout(() => {
  //     setLoading(false);
  //   }, 2000);

  //   return () => clearTimeout(timer);
  // }, []);

  // if (loading) {
  //   return <Loading />;
  // }

  return (
    <AuthProvider>
      <div>
        <Navbar/>
        <main>
          <Outlet />
        </main>
        <Footer/>
      </div>
    </AuthProvider>
  );
}

export default App;
