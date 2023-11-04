from PIL import Image

image = Image.open("pixel_art_png/start_screen.png")

with open("image_convertie.txt", "w") as fichier_texte:
    largeur, hauteur = image.size
    for y in range(hauteur):
        for x in range(largeur):
            r, g, b, _ = image.getpixel((x, y))
            
            r_5bits = (r >> 3) & 0x1F
            g_6bits = (g >> 2) & 0x3F
            b_5bits = (b >> 3) & 0x1F
            
            pixel_16bits = (r_5bits << 11) | (g_6bits << 5) | b_5bits
            
            pixel_binaire = format(pixel_16bits, '016b')
            
            fichier_texte.write(f"{pixel_binaire}\n")

fichier_texte.close()
