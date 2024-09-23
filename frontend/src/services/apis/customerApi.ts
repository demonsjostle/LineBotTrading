import axios from "axios";

const API_HOST = import.meta.env.VITE_API_HOST;

export const getCustomer = async (line_user_id: string) => {
  try {
    const response = await axios.get(
      `${API_HOST}/store/customer/${line_user_id}/`,
    );
    return response.data;
  } catch (error) {
    console.error("Error fetching customer:", error);
    throw error;
  }
};

//create data
export const addCustomer = async (data: {
  name: string;
  line_user_id: string;
  picture_url: string;
}) => {
  try {
    const response = await axios.post(
      `${API_HOST}/store/customer/create/`,
      data,
      // authorizationHeaders,
    );
    return response.data;
  } catch (error) {
    console.error("Error adding customer:", error);
    throw error;
  }
};

export const updateCustomer = async (
  data: {
    phone?: string;
    email?: string;
    mt5_id?: string;
  },
  line_user_id: string,
) => {
  try {
    const response = await axios.put(
      `${API_HOST}/store/customer/${line_user_id}/`,
      data,
      // authorizationHeaders,
    );
    return response.data;
  } catch (error) {
    console.error("Error update customer:", error);
    throw error;
  }
};
