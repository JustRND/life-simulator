extends RefCounted

# Small curated pools, not an exhaustive representation of each country's cultures.
const POOLS = {
	"Argentina": [["Mateo","Santiago","Benjamín","Tomás","Nicolás","Joaquín"], ["Sofía","Valentina","Camila","Lucía","Martina","Emilia"], ["García","Fernández","Rodríguez","López","Martínez","Romero"]],
	"Australia": [["Oliver","Jack","Noah","William","Thomas","Henry"], ["Charlotte","Amelia","Olivia","Isla","Ava","Matilda"], ["Wilson","Taylor","Anderson","Campbell","Harris","Thompson"]],
	"Brazil": [["Miguel","Arthur","Heitor","Davi","Gabriel","Pedro"], ["Alice","Helena","Laura","Valentina","Manuela","Beatriz"], ["Silva","Santos","Oliveira","Souza","Pereira","Costa"]],
	"Canada": [["Liam","Noah","Oliver","William","Gabriel","Étienne"], ["Olivia","Emma","Charlotte","Alice","Florence","Léa"], ["Tremblay","Gagnon","Roy","Wilson","Martin","Campbell"]],
	"Denmark": [["William","Oscar","Carl","Emil","Oliver","Magnus"], ["Alma","Clara","Agnes","Emma","Freja","Sofia"], ["Jensen","Nielsen","Hansen","Pedersen","Andersen","Christensen"]],
	"France": [["Gabriel","Louis","Raphaël","Arthur","Jules","Lucas"], ["Louise","Jade","Alice","Emma","Chloé","Manon"], ["Martin","Bernard","Dubois","Laurent","Moreau","Simon"]],
	"Germany": [["Leon","Felix","Paul","Elias","Jonas","Lukas"], ["Emilia","Hannah","Mia","Emma","Clara","Lina"], ["Müller","Schmidt","Schneider","Fischer","Weber","Wagner"]],
	"India": [["Aarav","Arjun","Rohan","Vihaan","Aditya","Ishaan"], ["Aanya","Diya","Ananya","Kavya","Meera","Isha"], ["Sharma","Verma","Patel","Rao","Iyer","Gupta"]],
	"Indonesia": [["Aditya","Bima","Dimas","Fajar","Rizky","Wahyu","Bagas","Bayu","Arif","Rafi"], ["Ayu","Citra","Dewi","Intan","Putri","Ratna","Sari","Tiara","Nadia","Kirana"], ["Pratama","Saputra","Wijaya","Nugraha","Permana","Hidayat"]],
	"Ireland": [["Oisín","Cian","Fionn","Liam","Seán","Conor"], ["Aoife","Saoirse","Niamh","Ciara","Róisín","Éabha"], ["Murphy","Kelly","Sullivan","Walsh","Ryan","Byrne"]],
	"Italy": [["Leonardo","Francesco","Alessandro","Lorenzo","Matteo","Andrea"], ["Sofia","Giulia","Aurora","Alice","Ginevra","Beatrice"], ["Rossi","Russo","Ferrari","Esposito","Bianchi","Romano"]],
	"Japan": [["Haruto","Ren","Yuto","Sota","Minato","Kaito"], ["Himari","Yui","Aoi","Sakura","Hina","Mei"], ["Sato","Suzuki","Takahashi","Tanaka","Watanabe","Ito"]],
	"Mexico": [["Santiago","Mateo","Sebastián","Diego","Emiliano","Daniel"], ["Valentina","Ximena","Regina","Camila","Sofía","Mariana"], ["Hernández","García","Martínez","López","González","Pérez"]],
	"Netherlands": [["Noah","Daan","Finn","Sem","Lucas","Levi"], ["Emma","Julia","Sophie","Mila","Tess","Zoë"], ["Visser","Smit","Meijer","Bakker","Mulder","Bos"]],
	"Norway": [["Jakob","Emil","Noah","Oliver","Filip","Magnus"], ["Nora","Emma","Ella","Olivia","Ingrid","Sofie"], ["Hansen","Johansen","Olsen","Larsen","Andersen","Nilsen"]],
	"Portugal": [["Francisco","João","Afonso","Tomás","Duarte","Miguel"], ["Maria","Leonor","Matilde","Carolina","Beatriz","Inês"], ["Silva","Santos","Ferreira","Pereira","Oliveira","Costa"]],
	"Russia": [["Aleksandr","Dmitri","Ivan","Mikhail","Nikolai","Sergei"], ["Anastasia","Daria","Ekaterina","Irina","Maria","Olga"], ["Ivanov","Petrov","Smirnov","Sokolov","Volkov","Kuznetsov"]],
	"Singapore": [["Ryan","Ethan","Lucas","Aiden","Zhiwei","Junjie"], ["Chloe","Megan","Ashley","Xinyi","Jiawen","Yuting"], ["Tan","Lim","Lee","Ng","Ong","Goh"]],
	"South Africa": [["Sipho","Thabo","Themba","Lwazi","Sibusiso","Bongani"], ["Nomsa","Zanele","Lerato","Naledi","Thandi","Ayanda"], ["Nkosi","Dlamini","Khumalo","Mokoena","Ndlovu","Mabena"]],
	"South Korea": [["Minjun","Seojun","Jiho","Juwon","Doyun","Hyunwoo"], ["Seoyeon","Jiwoo","Seohyun","Haeun","Jiyu","Yejin"], ["Kim","Lee","Park","Choi","Jung","Kang"]],
	"Spain": [["Hugo","Martín","Mateo","Pablo","Lucas","Álvaro"], ["Lucía","Sofía","Martina","María","Paula","Daniela"], ["García","Rodríguez","González","Fernández","López","Sánchez"]],
	"Sweden": [["William","Lucas","Liam","Oscar","Hugo","Elias"], ["Alice","Maja","Elsa","Astrid","Wilma","Freja"], ["Andersson","Johansson","Karlsson","Nilsson","Eriksson","Larsson"]],
	"Switzerland": [["Noah","Liam","Matteo","Luca","Leon","Elias"], ["Mia","Emma","Sofia","Lena","Lina","Emilia"], ["Müller","Meier","Schmid","Keller","Weber","Huber"]],
	"United Kingdom": [["Oliver","George","Harry","Arthur","Charlie","Oscar"], ["Olivia","Amelia","Isla","Ava","Freya","Florence"], ["Smith","Jones","Taylor","Brown","Wilson","Davies"]],
	"United States": [["Liam","Noah","James","Elijah","Henry","Benjamin"], ["Olivia","Emma","Charlotte","Amelia","Sophia","Isabella"], ["Smith","Johnson","Williams","Brown","Davis","Miller"]],
}

static func random_name(country: String, female: bool) -> String:
	var pool: Array = POOLS[country]
	var given: String = pool[1 if female else 0].pick_random()
	var family: String = pool[2].pick_random()
	if country == "Russia" and female:
		family += "a"
	return given + " " + family

