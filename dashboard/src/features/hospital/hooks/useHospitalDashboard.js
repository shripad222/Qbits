import { useEffect, useState } from "react";

export default function useHospitalDashboard() {
  const [stats, setStats] = useState({
    patients: 0,
    doctors: 0,
    nurses: 0,
    appointments: 0,
  });

  const [staff, setStaff] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  // Fetch dashboard data (could be from Supabase, Firebase, or an API)
  const fetchDashboardData = async () => {
    try {
      setLoading(true);
      setError(null);

      // Replace with your actual API or DB call
      const response = await fetch("/api/dashboard");
      if (!response.ok) throw new Error("Failed to fetch dashboard data");

      const data = await response.json();

      setStats({
        patients: data.patients ?? 0,
        doctors: data.doctors ?? 0,
        nurses: data.nurses ?? 0,
        appointments: data.appointments ?? 0,
      });

      setStaff(data.staff ?? []);
    } catch (err) {
      setError(err.message || "Something went wrong");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchDashboardData();
  }, []);

  // Optionally: refresh data manually
  const refresh = () => {
    fetchDashboardData();
  };

  return {
    stats,
    staff,
    loading,
    error,
    refresh,
  };
}
