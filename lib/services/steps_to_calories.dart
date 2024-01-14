
const double caloriesPerKilogramPerMinute = 0.035; // Caloric expenditure per kg per minute
const double stepsToKilometers = 0.000762; // Conversion factor from steps to kilometers

// Function to calculate calories burned based on steps
double calculateCaloriesBurned(int steps, double bodyWeightInKilograms) {
  // Convert steps to kilometers
  double distanceInKilometers = steps * stepsToKilometers;

  // Calculate time spent in minutes (assuming a pace of 1 km in 10 minutes)
  double timeInMinutes = distanceInKilometers * 10.0;

  // Calculate calories burned using the MET formula
  double caloriesBurned = caloriesPerKilogramPerMinute * bodyWeightInKilograms * timeInMinutes;

  return caloriesBurned;
}

double distanceCovered(int steps)
{
  return steps * stepsToKilometers;
}
