import axios from "axios";

const API_HOST = import.meta.env.VITE_API_HOST;

export const getPackages = async () => {
  try {
    const response = await axios.get(`${API_HOST}/store/package/`);
    return response.data;
  } catch (error) {
    console.error("Error fetching packages:", error);
    throw error;
  }
};
