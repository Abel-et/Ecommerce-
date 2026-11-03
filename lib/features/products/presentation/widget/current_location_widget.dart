
import 'package:ecommerce/core/utility/location_service.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_it/get_it.dart';
final sl = GetIt.instance;
class CurrentLocationWidget extends StatefulWidget {
final UserEntity user;
  const CurrentLocationWidget({
    super.key,
    required this.user
   });

  @override
  State<CurrentLocationWidget> createState() =>
      _CurrentLocationWidgetState();
}

class _CurrentLocationWidgetState
    extends State<CurrentLocationWidget> {

  // Location service handles GPS and permissions.
  final LocationService _locationService = LocationService();


  // Geocoding instance (required in geocoding 5.x).
  final Geocoding _geocoding = Geocoding();
  TextStyle textStyle (){
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16
    );
  }

  late Future<Map<String, String>> _locationAddressFuture;

  @override
  void initState() {
    super.initState();

    _locationAddressFuture = _fetchCityAndTown();
  }

  // Get coordinates and convert them into an address.
  Future<Map<String, String>> _fetchCityAndTown() async {

    // STEP 1: Get current GPS coordinates.
    Position position =
        await _locationService.determineCurrentLocation();

    // STEP 2: Reverse geocoding.
    List<Placemark> placemarks =
        await _geocoding.placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // STEP 3: Check whether an address was found.
    if (placemarks.isEmpty) {
      throw Exception('No address information found.');
    }

    // STEP 4: Get the most relevant address.
    Placemark place = placemarks.first;

    // STEP 5: Extract town and city.
    String town = _getFirstAvailable([
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
    ]);

    String city = _getFirstAvailable([
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
    ]);

    return {
      'town': town,
      'city': city,
    };
  }

  // Return the first non-empty address field.
  String _getFirstAvailable(List<String?> values) {
    for (final value in values) {
      if (value != null && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    return 'Unknown';
  }



  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(6),
      
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide.none
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<Map<String, String>>(
          future: _locationAddressFuture,

          builder: (context, snapshot) {

            // LOADING STATE
            // if (snapshot.connectionState ==
            //     ConnectionState.waiting) {
            //   return const Center(
            //     child: Padding(
            //       padding: EdgeInsets.all(16),
            //       child: CircularProgressIndicator(),
            //     ),
            //   );
            // }

            // ERROR STATE
            if (snapshot.hasError) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_off,
                    color: Colors.red,
                    size: 40,
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Unable to fetch your location',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 12),

                
                ],
              );
            }

            // SUCCESS STATE
            if (snapshot.hasData) {
              final address = snapshot.data!;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

             

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                         Text(
                      'Hello, ${
                        widget.user.fullName

                      }',
                          style: textStyle()
                        ),

                        const SizedBox(height: 8),


                        Row(
                          children: [
                            Text(
                              ' ${address['town']}/',
                              style: textStyle(),
                            ),
                              Text(
                          '${address['city']}',
                           style: textStyle()
                        ),
                          ],
                        ),

                      
                      ],
                    ),
                  ),

                  TextButton(
                    onPressed: (){},
                    child: Text('Change info',
                    style : TextStyle(fontSize: 14,fontWeight: FontWeight.bold, color:Colors.lightBlue)
                    ),
                   
                  ),
                ],
              );
            }

            return const Text(
              '',
            );
          },
        ),
      ),
    );
  }
}
