package br.com.douglas;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.*;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class WebScrapingTest {
    public static void main(String[] args) throws Exception {
    String url = "https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos";

    Document doc = Jsoup.connect(url)
            .timeout(15000)
            .get();
    Elements links = doc.select("a[href]");

    int count = 0;

   for (Element link : links) {
       String href = link.absUrl("href");
       String texto = link.text().toLowerCase();

       if (href.endsWith(".pdf") && texto.contains("anexo")) {
           count++;
           String filename = "Anexo_" + (count == 1 ? "I" : "II") + ".pdf";
           System.out.println("Baixado: " + filename + " - " + href);
           downloadPDF(href, filename);

           if (count == 2) break;
       }
   }

    zipFiles(new String[] {"Anexo_I.pdf", "Anexo_II.pdf"}, "anexos.zip")            ;
    System.out.println("Arquivos compactados com sucesso!");

    }

    private static void downloadPDF(String fileURL, String filename) throws IOException {
        if (Files.exists(Paths.get(filename))) {
            System.out.println("Arquivo já existe. " + filename);
            return;
        }


        try (InputStream in = new URL(fileURL).openStream()) {
            Files.copy(in, Paths.get(filename), StandardCopyOption.REPLACE_EXISTING);
            System.out.println("Baixado com sucesso " + filename);
        }
    }


    private static void zipFiles(String[] files, String zipFileName) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(zipFileName);
            ZipOutputStream zos = new ZipOutputStream(fos)) {

        for (String file : files) {
            File f = new File(file);
            if (!f.exists()) {
                System.out.println("Arquivo não encontrado: " + file);
                continue;
            }

            try (FileInputStream fis = new FileInputStream(file)) {
                ZipEntry ze = new ZipEntry(file);
                zos.putNextEntry(ze);

                byte[] bytes = new byte[1024];
                int length;
                while ((length = fis.read(bytes)) >= 0) {
                    zos.write(bytes, 0, length);
                }
                zos.closeEntry();
            }
        }

            }


    }


}
