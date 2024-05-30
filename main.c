#include <allegro5/allegro.h>
#include <allegro5/allegro_primitives.h>
#include <stdio.h>

extern void bezier(char* bitmap, int width, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int x5, int y5);

int main(int argc, char **argv) {
    int width = 800;
    int height = 600;

    if (argc >= 3){
        width = atoi(argv[1]);
        height = atoi(argv[2]);
    }

    // Bitmap and display initialization
    al_init();
    al_init_primitives_addon();
    ALLEGRO_DISPLAY *display = NULL;
    ALLEGRO_EVENT_QUEUE *event_queue = NULL;
    ALLEGRO_BITMAP *bitmap = NULL;
    ALLEGRO_LOCKED_REGION *locked_region = NULL;

    display = al_create_display(width, height);
    event_queue = al_create_event_queue();

    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_install_mouse();
    al_register_event_source(event_queue, al_get_mouse_event_source());

    al_set_new_bitmap_format(ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA);
    bitmap = al_create_bitmap(width, height);

    al_set_target_bitmap(bitmap);
    al_clear_to_color(al_map_rgba(255, 255, 255, 255));

    al_set_target_backbuffer(display);
    al_clear_to_color(al_map_rgb(0, 0, 0));
    al_draw_bitmap(bitmap, 0, 0, 0);
    al_flip_display();


    bool running = true;
    int p[5][2];
    int ind = 0;
    while (running) {
        ALLEGRO_EVENT ev;
        al_wait_for_event(event_queue, &ev);

        if (ev.type == ALLEGRO_EVENT_DISPLAY_CLOSE) {
            running = false;
        }
        else if (ev.type == ALLEGRO_EVENT_MOUSE_BUTTON_DOWN && ev.mouse.button) {
            printf("Kliknieto na pozycji: (%x, %x)\n", ev.mouse.x, ev.mouse.y);
            p[ind][0] = ev.mouse.x;
            p[ind][1] = ev.mouse.y;
            al_draw_filled_circle(ev.mouse.x, ev.mouse.y, 3, al_map_rgba(255, 0, 0, 255));
            ind++;
            al_flip_display();
            if (ind > 4){
                // clear bitmap
                al_destroy_bitmap(bitmap);
                bitmap = al_create_bitmap(width, height);

                // start drawing
                locked_region = al_lock_bitmap(bitmap, ALLEGRO_PIXEL_FORMAT_ANY_32_WITH_ALPHA, ALLEGRO_LOCK_WRITEONLY);
                printf("Drawing bezier\n");
                bezier(locked_region->data, width, p[0][0], p[0][1], p[1][0], p[1][1], p[2][0], p[2][1], p[3][0], p[3][1], p[4][0], p[4][1]);
                al_unlock_bitmap(bitmap);
                
                // display results
                al_draw_bitmap(bitmap, 0, 0, 0);
                al_flip_display();
                al_clear_to_color(al_map_rgb(255, 255, 255));
                ind = 0;
            }
        }
    }

    // clear memory
    al_destroy_bitmap(bitmap);
    al_destroy_event_queue(event_queue);
    al_destroy_display(display);

    return 0;
}
