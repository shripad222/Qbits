import axios from 'axios';

const NOMINATIM_BASE_URL = 'https://nominatim.openstreetmap.org';
const USER_AGENT = 'smart_blood_availability_app/1.0 (+email@example.com)';

/**
 * Geocode an address to get coordinates
 * @param {string} street - Street address
 * @param {string} city - City name
 * @param {string} state - State/Province name
 * @returns {Promise<Object|null>} Coordinates and pincode if found
 */
export const geocodeAddress = async (street, city, state) => {
  const addressParts = [];
  if (street) addressParts.push(street);
  if (city) addressParts.push(city);
  if (state) addressParts.push(state);

  const address = addressParts.join(', ');
  if (!address) return null;

  try {
    const response = await axios.get(`${NOMINATIM_BASE_URL}/search`, {
      params: {
        q: address,
        format: 'json',
        addressdetails: '1',
        limit: '1',
      },
      headers: {
        'User-Agent': USER_AGENT,
      },
    });

    if (response.data && response.data.length > 0) {
      const item = response.data[0];
      const lat = parseFloat(item.lat) || 0;
      const lon = parseFloat(item.lon) || 0;
      
      const result = {
        coordinates: { lat, lon },
        pincode: null,
      };

      // Extract pincode from address details
      if (item.address && item.address.postcode) {
        result.pincode = item.address.postcode.toString();
      }

      return result;
    }

    return null;
  } catch (error) {
    console.error('Geocoding error:', error);
    throw new Error('Failed to geocode address');
  }
};

/**
 * Reverse geocode coordinates to get address
 * @param {number} lat - Latitude
 * @param {number} lon - Longitude
 * @returns {Promise<Object|null>} Address details
 */
export const reverseGeocode = async (lat, lon) => {
  try {
    const response = await axios.get(`${NOMINATIM_BASE_URL}/reverse`, {
      params: {
        lat: lat.toString(),
        lon: lon.toString(),
        format: 'json',
        addressdetails: '1',
      },
      headers: {
        'User-Agent': USER_AGENT,
      },
    });

    if (response.data && response.data.address) {
      const addr = response.data.address;
      return {
        street: addr.road || addr.pedestrian || '',
        city: addr.city || addr.town || addr.village || '',
        state: addr.state || '',
        pincode: addr.postcode || '',
      };
    }

    return null;
  } catch (error) {
    console.error('Reverse geocoding error:', error);
    throw new Error('Failed to reverse geocode location');
  }
};

/**
 * Get current device position using Geolocation API
 * @returns {Promise<Object>} Position with latitude and longitude
 */
export const getCurrentPosition = () => {
  return new Promise((resolve, reject) => {
    if (!navigator.geolocation) {
      reject(new Error('Geolocation is not supported by your browser'));
      return;
    }

    navigator.geolocation.getCurrentPosition(
      (position) => {
        resolve({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
        });
      },
      (error) => {
        let message = 'Failed to get location';
        switch (error.code) {
          case error.PERMISSION_DENIED:
            message = 'Location permission denied';
            break;
          case error.POSITION_UNAVAILABLE:
            message = 'Location information unavailable';
            break;
          case error.TIMEOUT:
            message = 'Location request timed out';
            break;
        }
        reject(new Error(message));
      },
      {
        enableHighAccuracy: true,
        timeout: 10000,
        maximumAge: 0,
      }
    );
  });
};
