# HIGHWAY TO CLOUD — script del talk

Basato sul PDF `Highway to Cloud (4).pdf` (31 slide). Durata stimata: ~35 minuti le slide, ~40 con la demo (stime mie, non cronometrate).
Tra parentesi quadre le azioni sul palco; il resto è da dire a voce, con parole tue.

| Blocco | Slide | Minuti |
|---|---|---|
| Apertura | 1–4 | 3 |
| Il contesto: DevOps → platform | 5–9 | 6,5 |
| Costruire una IDP: scelta dei tool | 10–16 | 9 |
| Le sfide | 17–19 | 4 |
| Progettare una IDP: astrazioni e processi | 20–27 | 10,5 |
| Demo | 28 | 5 |
| Chiusura | 29–31 | 2,5 |
| **Totale** | | **40,5** (35,5 senza demo) |

---

## 1. Copertina (30")

Buongiorno a tutti, io sono Tommaso Liverani e oggi vi parlo di "Highway to Cloud": come
progettare una IDP che sia evolvibile e senza lock-in. Parleremo di DevOps, di platform
engineering e, ovviamente, di cloud.

## 2. Profile (30")

Lavoro come consulente IT in Imola Informatica da più di cinque anni. In questi anni ho
lavorato a diversi progetti DevOps e platform, ed è da lì che nasce questo talk. In fondo
trovate i miei contatti, se volete continuare la discussione dopo.

## 3. Outline (1')

Vi racconto di cosa parleremo:

- gli **obiettivi comuni** che ci si pone quando si adotta una IDP;
- le **difficoltà** che oggi si incontrano affrontando un progetto di platform;
- perché adottare una IDP **non è un progetto a scadenza**, ma l'inizio di un processo di
  adozione fatto di cambi di rotta, evoluzioni tecnologiche, esigenze che cambiano;
- e infine **come progettare una IDP che possa evolvere nel tempo**.

[Aneddoto, 20"] In questi anni ho visto che ogni progetto adottava i tool e i paradigmi più
in voga al momento del kickoff. Progetti nati a pochi mesi di distanza risultavano molto
diversi, e quelli più vecchi diventavano lentamente obsoleti. Fino all'ultimo, dove abbiamo
cambiato la domanda di partenza.

## 4. Intro: un nuovo approccio (1')

[Indico le due colonne] Di solito ci si chiede: *come costruisco una IDP?* Quindi: quali
requisiti, quali tool, quali paradigmi, quanti processi.

Nell'ultimo progetto ci siamo chiesti: *come **progetto** una IDP?* Quali obiettivi, quali
astrazioni, quale modellazione, e come generalizzo un processo.

La differenza è sottile ma cambia tutto: se parto dai tool, il disegno eredita la loro
scadenza. Se parto dalle astrazioni, i tool diventano una scelta rimpiazzabile. Questo è il
cuore del talk. Ma per arrivarci devo prima raccontarvi come siamo arrivati fin qui.

---

## 5. Il punto di partenza (1')

Due citazioni che per me riassumono il mondo DevOps.

**"You build it, you run it"** dice *cosa* vogliamo: autonomia. Chi sviluppa si prende in
carico anche l'esercizio.

**"If you don't automate yourself out of a job, someone else will"** dice *come*:
automazione. Nel mondo degli LLM fa sorridere ancora di più.

## 6. DevOps (1'30")

Intorno a questi due concetti c'è un mondo di parole chiave. Le cinque che contano per me:

- **Autonomia**: presa in carico del ciclo di vita del servizio, meno dipendenze tra team.
- **Collaborazione**: prima del DevOps ogni ufficio lavorava a silos; qui si abbattono,
  con obiettivi e responsabilità condivisi.
- **Velocità**: è il fine ultimo, e si misura. Deployment frequency, lead time for changes,
  change failure rate, time to restore service. Riducendo il feedback loop riduco il time
  to market, e finché il tempo sarà denaro è una metrica che resta.
- **Automazione**: la risposta agli obiettivi.
- **Cultura**: sta al centro. Senza quella gli strumenti non bastano.

## 7. Il problema (1'30")

[Mostro i due omini LEGO] Un DevOps engineer di dieci anni fa diceva: *"Build, deploy,
code, servers: that's all I needed"*. Quattro cose.

Il DevOps engineer di oggi ha davanti questo [indico il loghi attorno all'infinito].
Containerizzazione, orchestrazione, infrastructure as code, GitOps, osservabilità,
sicurezza, cloud managed. Ognuno di questi tool è diventato uno standard de facto, e ognuno
aggiunge una competenza che prima non serviva a chi doveva solo scrivere codice e portarlo
in produzione.

Il punto non è "quanti tool". Il punto è che "you build it, you run it" non regge più:
non posso chiedere a ogni team applicativo di essere esperto di tutto.

## 8. Platform (1'30")

Da qui nasce la platform: *"You build it, **the platform** will run it for you"*.
Tre idee:

- **Developer experience**: mi concentro sull'esperienza dell'utente, riducendo il carico
  cognitivo e offrendo self-service.
- **Platform as a product**: la platform è un prodotto interno, con utenti (gli sviluppatori),
  roadmap e product owner.
- **Everything as a service**: tutto ciò che serve a chi sviluppa viene esposto come servizio
  consumabile on-demand.

Una nota che trovo interessante: DevOps e platform engineering sono uno la conseguenza
dell'altro, ma spingono in direzioni quasi opposte. Il primo sull'autonomia del singolo team,
il secondo sulla riduzione del carico cognitivo collettivo. Non è una contraddizione, è
un'evoluzione.

## 9. Platform: gli obiettivi (1')

Cosa deve garantire una platform per funzionare:

- **Developer experience**: provisioning on-demand, autonomia tramite self-service, meno
  carico cognitivo.
- **Compliance**: security by design, policy enforcement, qualità.
- **Governance**: audit e tracciabilità, FinOps, gestione delle risorse.
- E, a tenere insieme tutto, **golden path** e **standardizzazione**.

Tenete a mente soprattutto "standardizzazione" e "responsabilità": sono il filo conduttore
di quello che vi mostro dopo.

---

## 10. Costruire una IDP (1'30")

Primo tema: *come costruisco una IDP?* Si parte dalla scelta dei tool, e secondo me i criteri
sono tre:

- **Modello operativo**: ogni tool porta con sé un paradigma. La scelta deve rispondere ai
  requisiti del progetto ed essere coerente con le risorse che gestisce.
- **Maturità e grado di adozione**: l'affidabilità nel tempo, misurata da stabilità,
  community attiva e longevità.
- **Neutralità rispetto al vendor**: non dipendere dalle decisioni di un'azienda esterna.

## 11. La scelta dei tool: CNCF (1')

Per la neutralità ci aiuta la **CNCF**, che dà tre garanzie: indipendenza da una singola
azienda, governance aperta e trasparente, e un percorso di maturità con pratiche consolidate.

## 12. Perché è difficile scegliere (1'30")

Eppure scegliere resta difficile, per quattro motivi:

- la CNCF conta **oltre 200 progetti**, in stati di maturità molto diversi;
- in molti ambiti **non c'è uno standard** consolidato;
- spesso il **tool più diffuso non coincide con la direzione tecnologica emergente**;
- e **anche un progetto maturo può essere archiviato**.

[Pausa] Scegliere non è difficile perché siamo impreparati, ma perché il panorama è fatto
per offrire opzioni di continuo.

## 13. Un esempio: tre approcci per l'infrastruttura (2')

Prendiamo un caso reale: gestire risorse cloud. Tre strade.

- **Terraform**: il più diffuso, multicloud, deploy "one-shot" con `apply`, drift visibile
  solo con un `plan`. Ma dalla 1.6 la licenza è quella di HashiCorp, e OpenTofu, il fork,
  è in CNCF come incubating.
- **Crossplane**: CNCF graduated dal 28 ottobre 2025, riconciliazione continua, drift
  detection e remediation automatica, multicloud. Adozione ancora limitata: nel CNCF Annual
  Survey del 2025 risulta usato in produzione dal 7%.
- **Operator del cloud provider**: supporto ufficiale del provider, riconciliazione
  continua, ma legato a uno specifico cloud e con adozione limitata.

## 14. Il confronto (1')

[Slide con le spunte] Ho messo i tre a confronto su cinque criteri: CNCF, supporto del
provider, ampia adozione, multi-cloud, allineamento continuo.

Nessuno li soddisfa tutti. Terraform vince sull'adozione ma non è CNCF e non allinea
continuamente. Crossplane è CNCF e multicloud ma poco adottato. L'operator del provider ha
supporto ufficiale ma è legato a un solo cloud.

Non c'è una risposta giusta: dipende dal contesto, e il contesto cambia.

## 15. Pattern 1: deploy "one shot" (1')

Dietro la scelta c'è un paradigma. Il primo è il **deploy one-shot**: eseguo un comando di
apply quando lo decido io, la remediation è manuale e solo se voglio, il dry-run è un
execution plan esplicito, e lo stato attuale sta su un backend esterno.

## 16. Pattern 2: Kubernetes come control plane (1')

Il secondo è **Kubernetes come control plane**: la riconciliazione continua con il suo
reconciliation loop, tutto l'ecosistema k8s (RBAC, Argo, Prometheus, Kyverno), estendibilità
nativa tramite CRD, e Kubernetes come single source of truth.

---

## 17. Challenges: la parte tecnica (2')

Nessuno dei due è gratis. Il secondo paradigma ha quattro sfide:

- **Complessità**: tante CRD e provider, e un control plane da gestire.
- **Dipendenze circolari**: come creo il cluster che fa da control plane? E devo comunque
  usare più tool per lo stesso scopo.
- **Overhead**: un control plane in più per l'autonomia regionale o per quella del tenant.
- **Lifecycle mismatch**: actual state → reconciliation → desired state non è adatto a tutte
  le risorse infrastrutturali.

[Aggancio la demo] La dipendenza circolare la vedremo nella demo: per creare un cluster non
posso usare il cluster stesso.

## 18. Challenges: la parte di business (1'30")

Poi c'è il problema di *vendere* una platform:

- **Valore indiretto**: la platform non crea valore direttamente e non è il main business.
- **Modalità operativa**: nuovi workflow e responsabilità ridefinite.
- **Imposizione di uno standard**: non tutto può essere supportato e servono processi di
  adeguamento.
- **Deresponsabilizzazione**: "in locale funziona", "è colpa della pipeline".

E non posso vendere una platform a chi pensa di averla già comprata due anni fa.

## 19. Sum up (30")

Riassumo: la scelta del tool, la scelta del paradigma, le difficoltà di business. Tutte e tre
cambiano nel tempo, quindi mi serve **un progetto flessibile e evolvibile**. E qui comincia
la seconda parte: come lo progetto.

---

## 20. Astrazioni: il building block (1'30")

Parto da due astrazioni. La prima è il **building block**: l'unità minima rilasciabile
sulla mia infrastruttura. Un bucket S3 su AWS, un cluster AKS su Azure, un repository git.

Deve essere tre cose:

- **versionabile**: posso versionare su git tutto ciò che serve a farne il provisioning;
- **testabile**: posso misurare se rispetta criteri funzionali, di qualità o compliance;
- **rilasciabile**: esiste un processo automatico che lo crea.

[Nella demo: lo stesso bucket ha due building block, un modulo Terraform e una composition
Crossplane, con gli stessi input e gli stessi output.]

## 21. Astrazioni: il template (1'30")

La seconda è il **template**: la definizione riutilizzabile di *come creare* una risorsa.

- **Parametrico**: definisce come creare o modificare la risorsa a partire da parametri.
- **Specifico per tecnologia**: è legato a un solo tool.
- **Dipende dal building block**: lo usa e ne definisce l'integrazione, senza duplicare la
  logica implementativa.

Quindi: il building block sa *cosa* è la risorsa, il template sa *come chiederla* a un tool.

## 22. Processi: più tool, più deploy (1')

Come gestisco più tool? Con un **processo di deploy differenziato**: ogni tool ha il suo.
Ma per risorse complesse non basta: ho bisogno di una struttura più articolata.

## 23. Processi: la soluzione dei principali tool (1'30")

[Slide con i provider] La soluzione che offrono i tool è questa: uno stesso building block
passa per più provider, uno per AWS che crea, uno per Helm che fa upgrade, uno per Argo che
crea.

I problemi: **cicli di vita dipendenti**, **responsabilità non separabili**, **stati non
sempre rappresentabili**, **scarsa riutilizzabilità**. Per me non è adatta a un contesto
enterprise.

## 24. Processi: il templater e lo scaffolding plan (1'30")

La soluzione che propongo è un **templater**. Non deploya: genera il codice. Dato uno
**scaffolding plan** produce i componenti di una risorsa, ciascuno con il suo processo di
deploy: uno crea, uno fa upgrade, uno sincronizza.

I vantaggi: **cicli di vita separati**, **processi di deploy dedicati**, **responsabilità
differenziabili** (chi scrive il template non è chi lo rilascia) e **building block
riutilizzabili**.

## 25. Processi: le interfacce (1')

Per costruire una risorsa servono spesso configurazioni con **ownership diversa**: la
platform decide la regione, la security decide la cifratura, l'utente decide il nome.

Le chiamo **interfacce**: ognuna è una sorgente di configurazioni in carico a un ufficio o a
un utente. Al template resta il compito di stabilire come aggregarle. In questo modo le
responsabilità sono scritte in file diversi, con proprietari diversi.

## 26. Processi: lo scaffolding di una risorsa (1'30")

Mettiamo insieme i pezzi. Il templater fa tre cose: **aggrega le interfacce**, **rende i
template**, **pubblica** su git. Da lì partono i deploy, ognuno col suo tool: creare un
bucket su AWS, fare un upgrade con Helm, creare un'applicazione Argo.

E se devo fare un'operazione su una risorsa che esiste già?

## 27. Processi: la modifica di una risorsa (1')

Un template può definire anche **come modificare una risorsa esistente**: il templater
aggrega le interfacce, rende il template partendo da quello che c'è già e pubblica
l'aggiornamento.

Il processo è **generico ed estensibile**: aggiungere un'operazione significa scrivere un
template in più, non cambiare il processo.

---

## 28. Demo (5')

[Passo a Backstage. Piano B se non c'è rete: registrazione o screenshot.]

**Cosa mostro, in quest'ordine**

1. **Catalogo dei servizi.** In Backstage il template "storage" è un servizio della platform.
   Compilo il form con il solo nome. Non scelgo il tool.
2. **Il templater.** Parte il workflow su GitHub Actions. Mostro i log: carica le
   interfacce (platform, security), rende i template e apre **una pull request per
   componente**.
3. **Il codice generato.** Nella PR si vede la cartella `resources/s3-bucket-<nome>` con il
   parametro file e il `.idp.yaml` con il tipo di deploy. Faccio il merge: parte il deploy.
4. **Lo stesso servizio con un altro tool.** In `service-info.yaml` cambio
   `scaffolding_plan` da Terraform a Crossplane. Un nuovo bucket produce un `S3Bucket` e
   un'Application Argo CD, non più `variables.json`. Il bucket di prima resta su Terraform:
   il tool scelto è registrato nel catalogo delle risorse.
5. **Una modifica.** Dal servizio "enable storage retention" scelgo un bucket esistente: il
   template riceve quello che c'è già e aggiunge solo la retention.
6. **(Se c'è tempo) Il cluster.** Il servizio `create_cluster` crea un cluster k3s con
   Ansible, installa Argo CD con Helm (chart ombrello) e il root app-of-apps con kubectl.
   Risponde alla dipendenza circolare della slide 17: il cluster non lo crea il cluster.

**Frase di chiusura della demo**

Notate che il form, il catalogo e il processo sono rimasti uguali. Quello che è cambiato è
un'etichetta e un template.

---

## 29. Sum up: una platform evolvibile (1')

Cosa succede quando qualcosa cambia:

- **Nuovo tool da gestire**: sviluppo i nuovi processi di deploy.
- **Nuova risorsa**: posso crearla con i building block che ho? Se sì, definisco un nuovo
  template. Se no, sviluppo i building block e poi il template.
- **Nuova operazione**: implemento il template che risponde alla richiesta.

In ogni caso so già *dove* intervenire. Il percorso del cambiamento è scritto nel progetto.

## 30. Conclusioni: key takeaways (1')

Quattro cose da portare a casa:

1. **Problemi e scelte**: costruire una IDP significa gestire scelte tecnologiche e
   architetturali e affrontare problemi tecnici e di business.
2. **Lungo processo di adozione**: le difficoltà non si risolvono introducendo la platform, si
   propagano per tutta la sua vita.
3. **Progetto evolvibile**: il fattore chiave è definire fin dall'inizio i percorsi per un
   cambio tecnologico o una nuova capability.
4. **Progetto basato su astrazioni**: building block, template, interfacce e processi
   rendono tutto questo possibile.

## 31. Grazie (30")

Grazie a tutti. Il codice della demo è su GitHub (link nella slide del profilo): chi vuole
può provarlo. Se avete domande, sono qui.

---

## Domande probabili

- **"Perché non Backstage da solo con lo skeleton?"** Perché diventerei dipendente dal
  motore di template di Backstage: qui Backstage è solo il front-end e la logica sta nel
  processo.
- **"Il templater non è un altro tool a cui sono legato?"** Sì, ma è piccolo, versionato nel
  repo e sostituibile: le astrazioni (building block, template, interfacce) restano.
- **"Cosa succede ai bucket creati con Terraform se cambio il default?"** Niente: il tool è
  registrato per istanza, il cambio vale solo per le nuove.
- **"E la rimozione di una risorsa?"** Non c'è ancora un servizio di decommission: è il
  prossimo passo.
