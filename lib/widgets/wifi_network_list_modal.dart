import 'package:flutter/material.dart';
import '../screens/final_step_screen.dart';

class WifiNetworkListModal extends StatefulWidget {
  final String plantNickname;
  final String imageUrl;

  const WifiNetworkListModal({
    super.key,
    required this.plantNickname,
    required this.imageUrl,
  });

  @override
  State<WifiNetworkListModal> createState() => _WifiNetworkListModalState();
}

class _WifiNetworkListModalState extends State<WifiNetworkListModal> {
  // Mock network list
  final List<String> networks = [
    'Said77',
    'Setup_8a77',
    '5GHT',
    'Achilleswifi',
    'Natalya',
    'Saed5692',
  ];

  String? networkStatus;
  bool showNavigatingText = false;

  void _showPasswordDialog(String networkName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController = TextEditingController();
        bool obscurePassword = true;
        
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: SizedBox(
                width: 345,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // WiFi Title
                        const Text(
                          'WiFi',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Subtitle
                        const Text(
                          'Enter network information',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Network Name Section
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Network Name',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                networkName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Password Section
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Network Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 56,
                          child: TextField(
                            controller: passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(
                              color: Color(0xFF797979),
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                color: Color(0xFF797979),
                                fontSize: 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 2, color: Color(0xFFE0E0E0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 2, color: Color(0xFFE0E0E0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(width: 2, color: Color(0xFFE0E0E0)),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    obscurePassword = !obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    networkStatus = 'Connecting...';
                                  });
                                  
                                  await Future.delayed(const Duration(seconds: 5));
                                  
                                  setState(() {
                                    networkStatus = 'Connected!';
                                  });
                                  
                                  await Future.delayed(const Duration(seconds: 1));
                                  setState(() {
                                    networkStatus = 'Connected!';
                                    showNavigatingText = true;
                                  });
                                  
                                  await Future.delayed(const Duration(seconds: 1));
                                  
                                  if (mounted) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FinalStepScreen(
                                          plantNickname: widget.plantNickname,
                                          sensorId: 'Rootin Sensor 2067',
                                          networkName: networkName,
                                          imageUrl: widget.imageUrl,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text(
                                  networkStatus ?? 'Connect',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (showNavigatingText)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Navigating to final step...',
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.7),
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header with close button and title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Networks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 40), // For balance
              ],
            ),
          ),

          // Network list
          Expanded(
            child: ListView.builder(
              itemCount: networks.length,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      networks[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock, size: 20),
                        SizedBox(width: 8),
                        Icon(Icons.wifi, size: 20),
                      ],
                    ),
                    onTap: () => _showPasswordDialog(networks[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 