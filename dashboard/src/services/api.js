import axios from 'axios';

const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://10.79.215.218:3000';

/**
 * Register a new hospital
 * @param {FormData} formData - Form data containing hospital information and files
 * @returns {Promise<Object>} Response from the server
 */
export const registerHospital = async (formData) => {
  try {
    const response = await axios.post(
      `${BACKEND_URL}/api/auth/add-hospital`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  } catch (error) {
    if (error.response) {
      // Server responded with error
      throw new Error(error.response.data.error || 'Registration failed');
    } else if (error.request) {
      // Request made but no response
      throw new Error('No response from server. Please check your connection.');
    } else {
      // Something else went wrong
      throw new Error(error.message || 'An unexpected error occurred');
    }
  }
};

/**
 * Register a new blood bank (for future use)
 * @param {FormData} formData - Form data containing blood bank information and files
 * @returns {Promise<Object>} Response from the server
 */
export const registerBloodBank = async (formData) => {
  try {
    const response = await axios.post(
      `${BACKEND_URL}/api/auth/add-blood-bank`,
      formData,
      {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      }
    );
    return response.data;
  } catch (error) {
    if (error.response) {
      throw new Error(error.response.data.error || 'Registration failed');
    } else if (error.request) {
      throw new Error('No response from server. Please check your connection.');
    } else {
      throw new Error(error.message || 'An unexpected error occurred');
    }
  }
};

export default axios.create({
  baseURL: BACKEND_URL,
});
