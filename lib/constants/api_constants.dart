class ApiConstants {
  // Base URL and version
  static const String baseUrl = 'https://api.rootin.me';
  static const String apiVersion = 'v1';

  // Headers
  static const String contentType = 'application/json';
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer';

  // Endpoints
  static const String plantsEndpoint = '/plants';
  static const String plantTypesEndpoint = '/plant-types';

  // Full URLs
  static String getPlantTypesUrl() => '$baseUrl/$apiVersion/plant-types';
  static String getPlantsUrl() => '$baseUrl/$apiVersion$plantsEndpoint';
  
  // Query Parameters
  static const String categoryIdParam = 'categoryId';
  static const String nicknameParam = 'nickname';
  static const String imageUrlParam = 'imageUrl';
  static const String plantTypeIdParam = 'plantTypeId';

  static String createCategoryUrl() => '$baseUrl/v1/categories';
} 