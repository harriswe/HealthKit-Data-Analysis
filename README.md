# HealthKit-Final-Project

This app leverages Apple's HealthKit framework to retrieve and analyze health data from your Apple Watch, with a special emphasis on heart rate information. It delivers detailed analytics and visualizations to help you gain insights into your health metrics.

**Note:** This project is a fork of the final project for CIS 357 01, created by Jerod Muilenburg and Wes Harrison.

## Features

- **Data Retrieval:** Pulls various health data from Apple Watch via HealthKit, including:
  - Heart rate
  - Steps
  - Sleep analysis
  - And additional metrics
- **Heart Rate Analytics:** Provides in-depth analysis of heart rate data, such as:
  - Average heart rate over selectable time periods (daily, weekly, monthly)
  - Heart rate trends and variability
  - Resting heart rate
- **Additional Insights:** Offers visualizations and insights into other health metrics available through HealthKit.

## Installation

To set up and run this app on your iPhone, follow these steps:

1. **Clone the Repository:** Download this repository to your local machine.
2. **Open in Xcode:** Navigate to the cloned directory and open the project by double-clicking `HealthKit-Final-Project.xcodeproj`.
3. **Enable HealthKit:** In Xcode, go to the project settings and ensure the HealthKit capability is enabled.
4. **Set Up Provisioning:** Select your development team and configure the necessary provisioning profiles.
5. **Connect Your Device:** Plug in your iPhone (paired with an Apple Watch) and select it as the build target.
6. **Build and Run:** Compile and launch the app from Xcode.

**Requirements:**
- Xcode 12 or later
- iOS 14 or later
- An iPhone paired with an Apple Watch

## Usage

1. **Launch the App:** Open the app on your iPhone.
2. **Grant Permissions:** When prompted, allow the app to access your HealthKit data.
3. **Data Retrieval:** The app will automatically fetch health data from your Apple Watch.
4. **Explore Analytics:** Navigate the app to view various analytics and visualizations of your health metrics.

## Healthcare Data Management and HIPPA Compliance

This app prioritizes the secure and responsible management of healthcare data, ensuring compliance with the **Health Insurance Portability and Accountability Act (HIPPA)**. Below is an overview of our healthcare data management processes and how we maintain HIPPA compliance:

- **Data Handling:**  
  The app retrieves health data from HealthKit only after obtaining explicit user permission. All processing of this data occurs locally on your device, reducing the risk of unauthorized access or exposure.

- **User Consent:**  
  Upon first use, the app prompts you to grant permission to access HealthKit data. You have full control and can revoke this permission at any time through your device's settings, ensuring your data is only accessed with your approval.

- **Data Security:**  
  Any health data stored locally by the app is protected with industry-standard encryption. Additionally, the app does not transmit your data to external servers unless you explicitly authorize it, safeguarding your privacy.

- **No Third-Party Sharing:**  
  Your health data is never shared with third parties without your explicit consent, aligning with HIPPA's strict requirements for protecting sensitive information.

- **HIPPA Compliance Statement:**  
  This app is designed to meet HIPPA standards for the protection of personal health information. We have implemented robust safeguards to ensure data privacy and security. However, as HIPPA compliance involves complex legal considerations, we recommend consulting a legal expert to confirm compliance in your specific use case.

We are committed to protecting your health data and maintaining your trust by adhering to the highest standards of privacy and security.

## Contributing

We welcome contributions! To contribute to this project:

1. **Fork the Repository:** Create your own copy of the repository.
2. **Create a Branch:** Make a new branch for your feature or bug fix.
3. **Make Changes:** Implement your changes and commit them with descriptive messages.
4. **Submit a Pull Request:** Open a pull request with a clear explanation of your modifications.

Please ensure your code adheres to the project's coding standards and includes relevant tests.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

---

**Original Project Credits:**  
This app is based on the final project for CIS 357 01 by Jerod Muilenburg and Wes Harrison.
