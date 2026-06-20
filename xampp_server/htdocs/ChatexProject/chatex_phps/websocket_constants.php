<?php

// File upload limits
const MAX_FILE_ATTACHMENT_SIZE = 100 * 1024 * 1024; // 100 MB
const MAX_IMAGE_ATTACHMENT_SIZE = 50 * 1024 * 1024; // 50 MB

// Base URL for uploaded files (adjust if your server IP changes)
const BASE_UPLOAD_URL = "http://10.0.2.2/ChatexProject/uploads";
const FILES_UPLOAD_DIR = __DIR__ . "/../uploads/files";
const MEDIA_UPLOAD_DIR = __DIR__ . "/../uploads/media";