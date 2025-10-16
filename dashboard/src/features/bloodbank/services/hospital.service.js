// Example service layer for hospital dashboard data.
// Replace fetch URLs with your backend endpoints or Supabase queries.

const API_BASE_URL = "/api";

export const hospitalService = {
  async getDashboardData() {
    const res = await fetch(`${API_BASE_URL}/dashboard`);
    if (!res.ok) throw new Error("Failed to fetch dashboard data");
    return res.json();
  },

  async getBloodBankData() {
    const res = await fetch(`${API_BASE_URL}/bloodbank`);
    if (!res.ok) throw new Error("Failed to fetch blood bank data");
    return res.json();
  },

  async getStaff() {
    const res = await fetch(`${API_BASE_URL}/staff`);
    if (!res.ok) throw new Error("Failed to fetch staff data");
    return res.json();
  },
};
