import { createContext, useContext, useEffect, useState } from "react";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [currentUser, setCurrentUser] = useState(null);

  // Check localStorage for user session
  useEffect(() => {
    const storedUser = localStorage.getItem("user");
    if (storedUser) {
      setCurrentUser(JSON.parse(storedUser));
    }
  }, []);

  // Sign in (Mock Function)
  const signInUser = (email, password) => {
    const mockUser = { email, name: "Demo User" }; // Mock user for demo purposes
    localStorage.setItem("user", JSON.stringify(mockUser));
    setCurrentUser(mockUser);
  };

  // Sign out
  const signOut = () => {
    localStorage.removeItem("user");
    setCurrentUser(null);
  };

  return (
    <AuthContext.Provider value={{ currentUser, signInUser, signOut }}>
      {children}
    </AuthContext.Provider>
  );
};

// Custom Hook to Access Auth
export const useAuth = () => {
  return useContext(AuthContext);
};