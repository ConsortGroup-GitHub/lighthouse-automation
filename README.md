# Automatisation d'audits Lighthouse

## 📌 Présentation
Ce projet fournit plusieurs scripts Bash pour exécuter des audits [Google Lighthouse](https://developers.google.com/web/tools/lighthouse) sur une liste d'URLs définie dans `Input/ListURLs.txt`. Chaque exécution génère des rapports (HTML, JSON, CSV) historisés dans un dossier `Reports/`. Une page web statique située dans `docs/index.html` permet ensuite de visualiser l'évolution des scores Lighthouse grâce au fichier `docs/lighthouse-history.csv`.

## ⚙️ Prérequis
Avant de commencer, assurez-vous de disposer des éléments suivants :

- **Node.js 18+** (inclut `npm`).
- **Google Chrome** ou **Chromium** installé localement (Lighthouse en a besoin pour lancer l'audit).
- L'outil Lighthouse installé globalement :
  ```bash
  npm install -g lighthouse
  ```
- (Optionnel) Serveur HTTP statique pour consulter `docs/index.html` en local (ex. `npx serve` ou l'extension "Live Server" de VS Code).

> 💡 Sous macOS vous pouvez installer Chrome via [Homebrew](https://brew.sh) : `brew install --cask google-chrome`. Sous Linux, installez `chromium` depuis votre gestionnaire de paquets.

## 🚀 Installation
1. Clonez le dépôt :
   ```bash
   git clone https://github.com/USERNAME/lighthouse-automation.git
   cd lighthouse-automation
   ```
2. Vérifiez que le dossier `Reports/` existe. S'il n'est pas présent (il est ignoré par Git), créez-le :
   ```bash
   mkdir -p Reports
   ```
3. Renseignez vos URLs cibles dans `Input/ListURLs.txt`, une par ligne.

## 🧪 Lancer des audits Lighthouse
Trois scripts sont disponibles selon vos besoins.

### 1. Mode automatique
```bash
./lighthouse-scan.sh
```
- Analyse chaque URL de `Input/ListURLs.txt`.
- Force les catégories **Accessibilité** et **Performance**.
- Produit les formats **HTML**, **JSON** et **CSV** pour chaque URL.
- Les fichiers sont nommés avec un horodatage et stockés dans `Reports/`.

### 2. Mode interactif
```bash
./lighthouse-scan-with-questions.sh
```
- Le script vous pose des questions pour choisir dynamiquement les formats de sortie (HTML, JSON, CSV) et les catégories (Performance, Accessibilité, Best Practices, SEO).
- Les entrées sont validées avant de lancer les audits.

### 3. Mode scriptable / CI
```bash
./lighthouse-scan-command-lines.sh [formats] [catégories]
```
- Paramétrez les formats et catégories via arguments (ex. `"html,csv" "performance,seo"`).
- Utilisez `all` (valeur par défaut) pour tout sélectionner.
- Si la variable d'environnement `CI=true`, Chrome est lancé en mode headless avec les bons indicateurs (`--headless --no-sandbox --disable-gpu`).

> ℹ️ Dans tous les cas, les rapports sont stockés dans `Reports/`. Pensez à ajouter `Reports/` à votre `.gitignore` si vous ne souhaitez pas versionner ces fichiers volumineux.

## 📊 Visualiser l'historique des scores
1. Les résultats agrégés au fil du temps doivent être compilés dans `docs/lighthouse-history.csv` (au format `date,url,performance,accessibility,best-practices,seo`).
2. Ouvrez la page `docs/index.html` via un serveur statique, par exemple :
   ```bash
   npx serve docs
   ```
3. Sélectionnez une URL dans la liste déroulante pour afficher l'évolution de ses scores sous forme de graphiques (Chart.js + PapaParse).

## ✅ Bonnes pratiques
- Ajoutez une étape d'audit Lighthouse à vos pipelines CI/CD en appelant `lighthouse-scan-command-lines.sh` avec les paramètres souhaités.
- Automatisez l'agrégation des résultats (par exemple via un job qui exporte les scores JSON/CSV vers `docs/lighthouse-history.csv`).
- Surveillez régulièrement les tendances pour identifier des régressions de performance, d'accessibilité ou de SEO.

## 🆘 Support
En cas de problème avec l'exécution des scripts ou l'installation, vérifiez les logs de la console. Assurez-vous également que Chrome/Chromium est détecté par Lighthouse et que les URLs listées sont accessibles depuis votre machine.
