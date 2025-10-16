import { Outlet } from 'react-router-dom';
import './App.css';
// import Navbar from './components/Navbar';
// import Footer from './components/Footer';
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
      <div className="flex flex-col min-h-screen">
        {/* <Navbar /> */}
        <main className="flex-grow">
          <Outlet />
        </main>
        {/* <Footer /> */}
      </div>
    </AuthProvider>
  );
}

export default App;
