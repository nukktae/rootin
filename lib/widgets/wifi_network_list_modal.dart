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

  void _showPasswordDialog(String networkName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController passwordController = TextEditingController();
        
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Connect to $networkName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter the password to connect to the network.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF6F6F6F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Color(0xFF6F6F6F)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                      ),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      setState(() {
                        networkStatus = 'Connecting...';
                      });
                      
                      await Future.delayed(const Duration(seconds: 2));
                      
                      setState(() {
                        networkStatus = 'Connected';
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
                    child: Text(
                      networkStatus ?? 'Connect',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.lock, size: 20),
                        const SizedBox(width: 8),
                        const Icon(Icons.wifi, size: 20),
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