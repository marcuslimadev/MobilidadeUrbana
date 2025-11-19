ALTER TABLE `general_settings` ADD `operating_country` TEXT NULL DEFAULT NULL AFTER `preloader_image`;
ALTER TABLE `zones` ADD `country` TEXT NULL DEFAULT NULL AFTER `status`;
ALTER TABLE `users` ADD `total_reviews` INT NOT NULL DEFAULT '0' AFTER `is_deleted`, ADD `avg_rating` DECIMAL(5,2) NOT NULL DEFAULT '0' AFTER `total_reviews`;
ALTER TABLE `general_settings` ADD `notification_audio` VARCHAR(255) NULL DEFAULT NULL AFTER `operating_country`; 
UPDATE `general_settings` SET `notification_audio` = '6766b6616b7fe1734784609.mp3' WHERE `general_settings`.`id` = 1;
