-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2026. Feb 25. 10:54
-- Kiszolgáló verziója: 10.4.32-MariaDB
-- PHP verzió: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `dbchatex`
--
CREATE DATABASE IF NOT EXISTS `dbchatex` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `dbchatex`;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `chats`
--

DROP TABLE IF EXISTS `chats`;
CREATE TABLE `chats` (
  `chat_id` int(11) NOT NULL,
  `is_group` tinyint(1) NOT NULL DEFAULT 0,
  `group_name` varchar(20) DEFAULT NULL,
  `group_profile_picture` longtext DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `chats`:
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `chat_members`
--

DROP TABLE IF EXISTS `chat_members`;
CREATE TABLE `chat_members` (
  `id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_admin` tinyint(1) NOT NULL DEFAULT 0,
  `joined_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `chat_members`:
--   `chat_id`
--       `chats` -> `chat_id`
--   `user_id`
--       `users` -> `id`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `friends`
--

DROP TABLE IF EXISTS `friends`;
CREATE TABLE `friends` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `friend_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `friends`:
--   `user_id`
--       `users` -> `id`
--   `friend_id`
--       `users` -> `id`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
CREATE TABLE `friend_requests` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `status` enum('pending') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `friend_requests`:
--   `sender_id`
--       `users` -> `id`
--   `receiver_id`
--       `users` -> `id`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `messages`
--

DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `chat_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) DEFAULT NULL,
  `message_text` varchar(5000) DEFAULT NULL,
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `messages`:
--   `chat_id`
--       `chats` -> `chat_id`
--   `receiver_id`
--       `users` -> `id`
--   `sender_id`
--       `users` -> `id`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `message_attachments`
--

DROP TABLE IF EXISTS `message_attachments`;
CREATE TABLE `message_attachments` (
  `attachment_id` int(11) NOT NULL,
  `message_id` int(11) NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `file_type` enum('file','image') NOT NULL,
  `download_url` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `message_attachments`:
--   `message_id`
--       `messages` -> `message_id`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `preferred_lang` text NOT NULL DEFAULT 'Magyar',
  `profile_picture` varchar(255) DEFAULT 'defpfp.svg',
  `username` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `password_reset_token` varchar(255) DEFAULT NULL,
  `password_reset_expires` datetime DEFAULT NULL,
  `status` enum('online','offline') NOT NULL DEFAULT 'online',
  `signed_in` tinyint(1) NOT NULL DEFAULT 0,
  `last_seen` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- TÁBLA KAPCSOLATAI `users`:
--

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `chats`
--
ALTER TABLE `chats`
  ADD PRIMARY KEY (`chat_id`);

--
-- A tábla indexei `chat_members`
--
ALTER TABLE `chat_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_id` (`chat_id`),
  ADD KEY `user_id` (`user_id`);

--
-- A tábla indexei `friends`
--
ALTER TABLE `friends`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`,`friend_id`),
  ADD KEY `friend_id` (`friend_id`);

--
-- A tábla indexei `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- A tábla indexei `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `chat_id_connetion_chats_chat_id` (`chat_id`),
  ADD KEY `sender_id_connection_users_id` (`sender_id`) USING BTREE,
  ADD KEY `receiver_id_connection_users_id` (`receiver_id`) USING BTREE,
  ADD KEY `sent_at` (`sent_at`);

--
-- A tábla indexei `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD PRIMARY KEY (`attachment_id`),
  ADD KEY `message_id` (`message_id`);

--
-- A tábla indexei `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `chats`
--
ALTER TABLE `chats`
  MODIFY `chat_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `chat_members`
--
ALTER TABLE `chat_members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `friends`
--
ALTER TABLE `friends`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `friend_requests`
--
ALTER TABLE `friend_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `message_attachments`
--
ALTER TABLE `message_attachments`
  MODIFY `attachment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `chat_members`
--
ALTER TABLE `chat_members`
  ADD CONSTRAINT `chat_members_ibfk_1` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`chat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `chat_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `friends`
--
ALTER TABLE `friends`
  ADD CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`friend_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `chat_id_connetion_chats_chat_id` FOREIGN KEY (`chat_id`) REFERENCES `chats` (`chat_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `receiver_id_connection_users_id` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sender_id_connection_users_id` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `message_attachments`
--
ALTER TABLE `message_attachments`
  ADD CONSTRAINT `message_attachments_ibfk_1` FOREIGN KEY (`message_id`) REFERENCES `messages` (`message_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
