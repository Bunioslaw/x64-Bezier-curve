#include <allegro5/allegro.h>
#include <allegro5/allegro_primitives.h>
#include <stdio.h>

extern void bezier(char* bitmap, int x1, int y1, int x2, int y2, int x3, int y3, int x4, int y4, int x5, int y5);

int main(int argc, char **argv) {

    // Bitmap and display initialization
    al_init();
    al_init_primitives_addon();
    ALLEGRO_DISPLAY *display = al_create_display(800, 600);
    ALLEGRO_EVENT_QUEUE *event_queue = al_create_event_queue();
    ALLEGRO_BITMAP *bitmap = al_create_bitmap(800, 600);

    al_register_event_source(event_queue, al_get_display_event_source(display));
    al_install_mouse();
    al_register_event_source(event_queue, al_get_mouse_event_source());


    al_set_target_bitmap(bitmap);
    al_clear_to_color(al_map_rgb(255, 255, 255));

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
            p[ind][0] = ev.mouse.x;
            p[ind][1] = ev.mouse.y;
            al_draw_filled_circle(ev.mouse.x, ev.mouse.y, 5, al_map_rgb(255, 0, 0));
            ind++;
            if (ind > 4){
                al_clear_to_color(al_map_rgb(255, 255, 255));   // clear bitmap
                printf_s("Drawing bezier\n");// call bezier function
                //bezier(bitmap, p[0][0], p[0][1], p[1][0], p[1][1], p[2][0], p[2][1], p[3][0], p[3][1], p[4][0], p[4][1]);
                ind = 0;
            }
            al_flip_display();
        }
    }

    // clear memory
    al_destroy_bitmap(bitmap);
    al_destroy_event_queue(event_queue);
    al_destroy_display(display);

    return 0;
}
