#include <iostream>
#include <unordered_map>
#include <cstring>

#include "poppler-document.h"
#include "poppler-page-renderer.h"
#include "poppler-page.h"

std::unordered_map<std::string,poppler::document*> cache;

poppler::document *get_document(char *filename, int str_len) {
	auto str = std::string(filename, str_len);
	auto document_it = cache.find(str);

	if (document_it != cache.end())
		return document_it->second;

	poppler::document *doc = poppler::document::load_from_file(str.c_str());
	if (doc)
		cache[filename] = doc;

#if 0
	if (doc) {
		for (auto k: doc->info_keys()) {
			std::cout << k << " -> "<< doc->info_key(k).to_utf8().data() << std::endl;
		}
		std::cout << std::endl;
		std::cout << "META:" << std::endl;
		std::cout << doc->metadata().to_utf8().data() << std::endl;
	}
#endif

	return doc;
}

extern "C" {

	uint num_pages(char *filename, int str_len) {
		auto doc = get_document(filename, str_len);
		if (doc)
			return doc->pages();
		else
			return -1;
	}

	/**
	 * You have to free buffer if this function returns success (>=0)
	 */
	int render_page(char *filename, int str_len, int page_num, int dpi, int *bmStride, int *bmWidth, int *bmHeight, int *bmDepth, const char **buffer) {
		auto doc = get_document(filename, str_len);

		*bmStride = 0;
		*bmWidth = 0;
		*bmHeight = 0;
		*bmDepth = 0;
		*buffer = 0;

		if (!doc)
			return -1;

		poppler::page_renderer pr;
		pr.set_render_hint(poppler::page_renderer::antialiasing, true);
		pr.set_render_hint(poppler::page_renderer::text_antialiasing, true);

		auto page = doc->create_page(page_num);
		if (!page)
			return -2;

		auto image = pr.render_page(page, dpi, dpi);

		*bmStride = image.bytes_per_row();
		*bmWidth = image.width();
		*bmHeight = image.height();
		switch (image.format()) {
			case poppler::image::format_mono:
				*bmDepth = 8;
				break;
			case poppler::image::format_rgb24:
				*bmDepth = 24;
				break;
			case poppler::image::format_argb32:
				*bmDepth = 32;
				break;
			default:
				// invalid format
				return -3;
		}

		auto size = image.bytes_per_row() * image.height();
		*buffer = (const char *) malloc(size);
		std::memcpy((void *) *buffer, (const void *) image.const_data(), size);

		return 0;
	}

	// on success, you have to free the returned buffer
	char *text_of_page(char *filename, int str_len, int page_num, int x, int y, int w, int h) {
		auto doc = get_document(filename, str_len);
		if (!doc)
			return NULL;

		auto page = doc->create_page(page_num);
		if (!page)
			return NULL;

		auto data = page->text(poppler::rectf(x, y, w, h), poppler::page::physical_layout).to_utf8();
		auto buffer = malloc(data.size());
		std::memcpy(buffer, data.data(), data.size());

		return (char *) buffer;
	}
}
