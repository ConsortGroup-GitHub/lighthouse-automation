#!/bin/bash

# Liste des formats et catégories autorisés
valid_formats=("html" "json" "csv")
valid_categories=("performance" "accessibility" "best-practices" "seo")

# Fonction pour supprimer les espaces et valider les formats
validate_formats() {
  local input="$1"
  # Supprimer les espaces
  input=$(echo "$input" | tr -d ' ')
  
  # Si l'utilisateur entre "all", on sélectionne tous les formats
  if [[ "$input" == "all" || -z "$input" ]]; then
    formats="${valid_formats[*]}" # Prend tous les formats
    formats=$(echo "$formats" | tr ' ' ',') # Convertir les espaces en virgules
    return 0
  fi

  IFS=',' read -ra user_formats <<< "$input"
  for format in "${user_formats[@]}"; do
    if [[ ! " ${valid_formats[*]} " =~ " $format " ]]; then
      echo "Erreur : Le format '$format' n'est pas valide. Formats valides : html, json, csv."
      return 1
    fi
  done
  formats="$input" # Mise à jour de la variable avec le format sans espaces
  return 0
}

# Fonction pour supprimer les espaces et valider les catégories
validate_categories() {
  local input="$1"
  # Supprimer les espaces
  input=$(echo "$input" | tr -d ' ')
  
  # Si l'utilisateur entre "all", on sélectionne toutes les catégories
  if [[ "$input" == "all" || -z "$input" ]]; then
    categories="${valid_categories[*]}" # Prend toutes les catégories
    categories=$(echo "$categories" | tr ' ' ',') # Convertir les espaces en virgules
    return 0
  fi

  IFS=',' read -ra user_categories <<< "$input"
  for category in "${user_categories[@]}"; do
    if [[ ! " ${valid_categories[*]} " =~ " $category " ]]; then
      echo "Erreur : La catégorie '$category' n'est pas valide. Catégories valides : performance, accessibility, best-practices, seo."
      return 1
    fi
  done
  categories="$input" # Mise à jour de la variable avec la catégorie sans espaces
  return 0
}

# Si le script est lancé en mode non interactif, définir des valeurs par défaut
formats="all"
categories="all"

# Si l'utilisateur souhaite entrer des formats ou catégories via des arguments
if [[ ! -z "$1" ]]; then
  formats="$1"
fi

if [[ ! -z "$2" ]]; then
  categories="$2"
fi

# Valider les formats et catégories avec les valeurs par défaut ou saisies
validate_formats "$formats"
validate_categories "$categories"

# Chemin du fichier contenant les URLs
file="Input/ListURLs.txt"

# Lire chaque ligne (chaque URL) du fichier et exécuter Lighthouse
while IFS= read -r url || [[ -n "$url" ]]; do
  echo "Exécution de Lighthouse pour l'URL : $url"
  
  # Obtenir la date et l'heure actuelles au format année-mois-jour-heure-minutes-secondes
  timestamp=$(date +"%Y%m%d-%H%M%S")
  
  # Générer le nom du fichier avec la date et l'heure
  base_filename="Reports/lighthouse-$(echo $url | sed 's/[:\/]/_/g')-$timestamp"
  
  # Ajouter une extension appropriée en fonction des formats sélectionnés
  if [[ "$formats" == "html" ]]; then
    base_filename="${base_filename}.html"
  elif [[ "$formats" == "json" ]]; then
    base_filename="${base_filename}.json"
  elif [[ "$formats" == "csv" ]]; then
    base_filename="${base_filename}.csv"
  fi
  
  if [ "$CI" = "true" ]; then
    chrome_flags="--headless --no-sandbox --disable-gpu"
  else
    chrome_flags=""
  fi

  # Exécution du scan Lighthouse avec les formats de sortie et catégories sélectionnés par l'utilisateur
  lighthouse "$url" --output "$formats" --only-categories "$categories" --output-path "$base_filename" --chrome-flags="$chrome_flags"
  
done < "$file"
