ALTER TABLE `admins` ADD `status` TINYINT(1) NOT NULL DEFAULT '1' AFTER `password`;

CREATE TABLE `permissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_guard_name_unique` (`name`,`guard_name`);

ALTER TABLE `permissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `guard_name` varchar(255) NOT NULL,
  `status` tinyint(4) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_name_guard_name_unique` (`name`,`guard_name`);

ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;


CREATE TABLE `model_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `model_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`model_id`,`model_type`),
  ADD KEY `model_has_permissions_model_id_model_type_index` (`model_id`,`model_type`);

ALTER TABLE `model_has_permissions`
  ADD CONSTRAINT `model_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE;


CREATE TABLE `model_has_roles` (
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `model_type` varchar(255) NOT NULL,
  `model_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `model_has_roles`
  ADD PRIMARY KEY (`role_id`,`model_id`,`model_type`),
  ADD KEY `model_has_roles_model_id_model_type_index` (`model_id`,`model_type`);

ALTER TABLE `model_has_roles`
  ADD CONSTRAINT `model_has_roles_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;


CREATE TABLE `role_has_permissions` (
  `permission_id` bigint(20) UNSIGNED NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE `role_has_permissions`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `role_has_permissions_role_id_foreign` (`role_id`);

ALTER TABLE `role_has_permissions`
  ADD CONSTRAINT `role_has_permissions_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `role_has_permissions_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

ALTER TABLE `coupons` CHANGE `minimum_amount` `minimum_amount` DECIMAL(28,8) NOT NULL DEFAULT '0';



INSERT INTO `permissions` (`id`, `name`, `guard_name`, `group_name`, `created_at`, `updated_at`) VALUES
(1, 'view rides', 'admin', 'manage rides', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(2, 'view zone', 'admin', 'zone', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(3, 'add zone', 'admin', 'zone', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(4, 'edit zone', 'admin', 'zone', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(5, 'view service', 'admin', 'service', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(6, 'add service', 'admin', 'service', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(7, 'edit service', 'admin', 'service', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(8, 'view coupon', 'admin', 'coupon', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(9, 'add coupon', 'admin', 'coupon', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(10, 'edit coupon', 'admin', 'coupon', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(11, 'view brand', 'admin', 'brand', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(12, 'add brand', 'admin', 'brand', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(13, 'edit brand', 'admin', 'brand', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(14, 'view vehicle model', 'admin', 'vehicle_model', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(15, 'add vehicle model', 'admin', 'vehicle_model', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(16, 'edit vehicle model', 'admin', 'vehicle_model', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(17, 'view vehicle year', 'admin', 'vehicle_year', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(18, 'add vehicle year', 'admin', 'vehicle_year', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(19, 'edit vehicle year', 'admin', 'vehicle_year', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(20, 'view vehicle color', 'admin', 'vehicle_color', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(21, 'add vehicle color', 'admin', 'vehicle_color', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(22, 'edit vehicle color', 'admin', 'vehicle_color', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(23, 'view rider rule', 'admin', 'rider_rule', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(24, 'add rider rule', 'admin', 'rider_rule', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(25, 'edit rider rule', 'admin', 'rider_rule', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(26, 'view driver verification form', 'admin', 'manage verification form', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(27, 'view vehicle verification form', 'admin', 'manage verification form', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(28, 'manage pages', 'admin', 'manage content', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(29, 'manage sections', 'admin', 'manage content', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(30, 'view admin', 'admin', 'manage admin', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(31, 'add admin', 'admin', 'manage admin', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(32, 'edit admin', 'admin', 'manage admin', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(33, 'view driver deposits', 'admin', 'driver deposits', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(34, 'approve driver deposits', 'admin', 'driver deposits', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(35, 'reject driver deposits', 'admin', 'driver deposits', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(36, 'view driver withdrawals', 'admin', 'driver withdrawals', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(37, 'approve driver withdrawals', 'admin', 'driver withdrawals', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(38, 'reject driver withdrawals', 'admin', 'driver withdrawals', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(39, 'view rider payment report', 'admin', 'rider report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(40, 'view rider login history', 'admin', 'rider report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(41, 'view rider notification history', 'admin', 'rider report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(42, 'view user tickets', 'admin', 'support ticket', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(43, 'answer tickets', 'admin', 'support ticket', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(44, 'close tickets', 'admin', 'support ticket', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(45, 'view roles', 'admin', 'manage roles', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(46, 'add role', 'admin', 'manage roles', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(47, 'edit role', 'admin', 'manage roles', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(48, 'assign permissions', 'admin', 'manage roles', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(49, 'view payment gateway', 'admin', 'manage gateways', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(50, 'update payment gateway', 'admin', 'manage gateways', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(51, 'view withdrawals methods', 'admin', 'manage gateways', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(52, 'update withdrawals methods', 'admin', 'manage gateways', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(53, 'view driver commission history', 'admin', 'driver report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(54, 'view driver notification history', 'admin', 'driver report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(55, 'view driver transaction history', 'admin', 'driver report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(56, 'view driver login history', 'admin', 'driver report', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(57, 'view riders', 'admin', 'manage riders', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(58, 'send notification to riders', 'admin', 'manage riders', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(59, 'ban riders', 'admin', 'manage riders', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(60, 'view rider notifications', 'admin', 'manage riders', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(61, 'update riders', 'admin', 'manage riders', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(62, 'view drivers', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(63, 'notification to all drivers', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(64, 'update driver balance', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(65, 'ban drivers', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(66, 'view driver notifications', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(67, 'update drivers', 'admin', 'manage drivers', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(68, 'view extension', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(69, 'update extension', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(70, 'view seo', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(71, 'update seo', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(72, 'view language', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(73, 'update language', 'admin', 'system utilities', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(74, 'general settings', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(75, 'brand settings', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(76, 'system configuration', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(77, 'notification settings', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(78, 'cron job settings', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(79, 'gdpr cookie', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(80, 'custom css', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(81, 'sitemap', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(82, 'robot', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(83, 'maintenance mode', 'admin', 'setting', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(84, 'view dashboard', 'admin', 'other', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(85, 'all reviews', 'admin', 'other', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(86, 'promotional notify', 'admin', 'other', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(87, 'manage subscribers', 'admin', 'other', '2025-06-16 00:43:44', '2025-06-16 00:43:44'),
(88, 'view application info', 'admin', 'other', '2025-06-16 00:43:44', '2025-06-16 00:43:44');

INSERT INTO `roles` (`id`, `name`, `guard_name`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'admin', 1, '2025-06-16 00:45:23', '2025-06-16 00:45:23');


INSERT INTO `role_has_permissions` (`permission_id`, `role_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(11, 1),
(12, 1),
(13, 1),
(14, 1),
(15, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(42, 1),
(43, 1),
(44, 1),
(45, 1),
(46, 1),
(47, 1),
(48, 1),
(49, 1),
(50, 1),
(51, 1),
(52, 1),
(53, 1),
(54, 1),
(55, 1),
(56, 1),
(57, 1),
(58, 1),
(59, 1),
(60, 1),
(61, 1),
(62, 1),
(63, 1),
(64, 1),
(65, 1),
(66, 1),
(67, 1),
(68, 1),
(69, 1),
(70, 1),
(71, 1),
(72, 1),
(73, 1),
(74, 1),
(75, 1),
(76, 1),
(77, 1),
(78, 1),
(79, 1),
(80, 1),
(81, 1),
(82, 1),
(83, 1),
(84, 1),
(85, 1),
(86, 1),
(87, 1),
(88, 1);


INSERT INTO `model_has_roles` (`role_id`, `model_type`, `model_id`) VALUES
(1, 'App\\Models\\Admin', 1);

ALTER TABLE `general_settings` ADD `timezone` TEXT NULL DEFAULT NULL AFTER `ride_cancel_time`;