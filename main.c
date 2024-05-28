#include <allegro5/allegro.h>
#include <allegro5/allegro_image.h>
#include <allegro5/allegro_primitives.h>
#include <allegro5/allegro_font.h>
#include <allegro5/allegro_ttf.h>
#include <stdio.h>

int main(int argc, char **argv) {
    // Inicjalizacja Allegro i dodatków
    if (!al_init()) {
        fprintf(stderr, "Nie można zainicjować Allegro!\n");
        return -1;
    }
    
    if (!al_init_image_addon()) {
        fprintf(stderr, "Nie można zainicjować dodatku obrazów Allegro!\n");
        return -1;
    }
    
    if (!al_init_primitives_addon()) {
        fprintf(stderr, "Nie można zainicjować dodatku prymitywów Allegro!\n");
        return -1;
    }
    
    if (!al_init_font_addon()) {
        fprintf(stderr, "Nie można zainicjować dodatku czcionek Allegro!\n");
        return -1;
    }
    
    if (!al_init_ttf_addon()) {
        fprintf(stderr, "Nie można zainicjować dodatku czcionek TTF Allegro!\n");
        return -1;
    }

    // Tworzenie okna
    ALLEGRO_DISPLAY *display = al_create_display(800, 600);
    if (!display) {
        fprintf(stderr, "Nie można utworzyć wyświetlacza!\n");
        return -1;
    }

    // Tworzenie tymczasowej bitmapy
    ALLEGRO_BITMAP *bitmap = al_create_bitmap(200, 200);
    if (!bitmap) {
        fprintf(stderr, "Nie można utworzyć bitmapy!\n");
        al_destroy_display(display);
        return -1;
    }

    // Ustawienie bitmapy jako docelowej dla rysowania
    al_set_target_bitmap(bitmap);

    // Wypełnianie bitmapy kolorem czerwonym
    al_clear_to_color(al_map_rgb(255, 0, 0));

    // Rysowanie niektórych prymitywów na bitmapie
    al_draw_filled_circle(100, 100, 50, al_map_rgb(0, 255, 0));  // zielone kółko
    al_draw_line(0, 0, 200, 200, al_map_rgb(0, 0, 255), 5);       // niebieska linia

    // Przywracanie domyślnego docelowego wyświetlacza
    al_set_target_backbuffer(display);

    // Przypisanie pętli głównej i timer
    ALLEGRO_EVENT_QUEUE *event_queue = al_create_event_queue();
    ALLEGRO_TIMER *timer = al_create_timer(1.0 / 60.0);
    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_register_event_source(event_queue, al_get_timer_event_source(timer));

    bool running = true;
    al_start_timer(timer);

    while (running) {
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if (ev.type == ALLEGRO_EVENT_TIMER) {
            // Czyszczenie ekranu na biało
            al_clear_to_color(al_map_rgb(255, 255, 255));
            
            // Rysowanie bitmapy na ekranie w środku okna
            al_draw_bitmap(bitmap, 300, 200, 0);

            // Aktualizacja ekranu
            al_flip_display();
        } else if (ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            running = false;
        }
    }

    // Sprzątanie
    al_destroy_bitmap(bitmap);
    al_destroy_display(display);
    al_destroy_event_queue(event_queue);
    al_destroy_timer(timer);

    return 0;
}
