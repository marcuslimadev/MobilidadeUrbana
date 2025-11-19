
CREATE TABLE `vehicle_models` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `vehicle_models`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vehicle_models_name_unique` (`name`);

CREATE TABLE `vehicle_colors` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `vehicle_colors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vehicle_colors_name_unique` (`name`);

  ALTER TABLE `vehicle_colors`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

CREATE TABLE `vehicle_years` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `vehicle_years`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `vehicle_years_name_unique` (`name`);
  ALTER TABLE `vehicle_years`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

 ALTER TABLE `drivers`
  DROP `brand_id`,
  DROP `vehicle_data`;

  ALTER TABLE `rides` ADD `tips_amount` DECIMAL(28,8) NOT NULL DEFAULT '0' AFTER `amount`; 

UPDATE `notification_templates` SET `email_status` = '0' WHERE `notification_templates`.`id` = 30; 
ALTER TABLE `bids` DROP `deleted_at`;
ALTER TABLE `general_settings` ADD `tips_suggest_amount` TEXT NULL DEFAULT NULL AFTER `apple_login`; 

ALTER TABLE `vehicle_models` ADD `brand_id` INT(10) UNSIGNED NOT NULL DEFAULT '0' AFTER `id`;
ALTER TABLE `vehicle_models` CHANGE `id` `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT;

ALTER TABLE `vehicle_models` CHANGE `status` `status` TINYINT(1) NOT NULL DEFAULT '1';


CREATE TABLE `vehicles` (
  `id` bigint UNSIGNED NOT NULL,
  `driver_id` int UNSIGNED NOT NULL DEFAULT '0',
  `service_id` int UNSIGNED NOT NULL DEFAULT '0',
  `brand_id` int UNSIGNED NOT NULL DEFAULT '0',
  `color_id` int UNSIGNED NOT NULL DEFAULT '0',
  `year_id` int UNSIGNED NOT NULL DEFAULT '0',
  `model_id` int UNSIGNED NOT NULL DEFAULT '0',
  `image` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_number` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `form_data` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);
  
ALTER TABLE `vehicles` MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

UPDATE `drivers` SET `vv` = '0';

INSERT INTO `notification_templates` (`act`, `name`, `subject`, `push_title`, `email_body`, `sms_body`, `push_body`, `shortcodes`, `email_status`, `email_sent_from_name`, `email_sent_from_address`, `sms_status`, `sms_sent_from`, `push_status`, `created_at`, `updated_at`) VALUES
('RIDE_PAYMENT_COMPLETE', 'Wallet Ride Payment', '-----', 'Ride Payment Completed', '-----', '-----', 'The ride payment is received. The Amount: {{amount}} {{site_currency}} and trx is {{trx}}', '{\n    \"trx\":\"Transaction number\",\"ride_uid\":\"Ride ID\",\"amount\":\"Amount of the ride\",\"post_balance\": \"Balance of the driver after ride payment\"\n}', 0, NULL, NULL, 0, '-----', 1, '2021-11-03 06:00:00', '2025-04-19 18:24:32');
