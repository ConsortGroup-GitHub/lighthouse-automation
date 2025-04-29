#!/bin/bash

# Chemin du fichier contenant les URLs
file="Input/ListURLs.txt"
echo "Le fichier des URLs est : $file"

# Lire chaque ligne (chaque URL) du fichier et exécuter Lighthouse
while IFS= read -r url || [[ -n "$url" ]]; do
  echo "Exécution de Lighthouse pour l'URL : $url"
  
  # Obtenir la date et l'heure actuelles au format année-mois-jour-heure-minutes-secondes
  timestamp=$(date +"%Y%m%d-%H%M%S")
  
  # Générer le nom du fichier avec la date et l'heure
  base_filename="Reports/lighthouse-$(echo $url | sed 's/[:\/]/_/g')-$timestamp"
  
  # Exécution du scan Lighthouse pour chaque URL avec sortie en HTML, JSON, et CSV
  lighthouse "$url" --only-categories=accessibility,performance --output html,json,csv --output-path "$base_filename"
  
done < "$file"
