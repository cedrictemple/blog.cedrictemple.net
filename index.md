---
layout: main
---

<main class="home" id="post" role="main" itemprop="mainContentOfPage" itemscope="itemscope" itemtype="http://schema.org/Blog">
    <div class="row">
    <div class="article">
  <div class="well">
    <h2>Notes pour plus tard</h2>
    <ul class="twocolumns">
        <li>Outils :
            <ul>
                        <li>sed</li>
                        <li><a class="post-link" href="/notes-pour-plus-tard/TAR-archivage-et-desarchivage-de-donnees/">tar</a></li>
                        <li>ssh</li>
                        <li>gzip/bzip2/zip/unzip</li>
                        <li>vim</li>
                </ul> <!-- OUTILS -->
        </li><!-- OUTILS -->
        <li>Système :
                <ul>
                        <li>/etc/network/interfaces</li>
                        <li>/etc/resolv.conf</li>
                        <li>systemd/systemctl</li>
                        <li>Apache</li>
                        <li>NGinx</li>
                        <li>MySQL</li>
                        <li>Amazon Web Services (AWS)</li>
                </ul> <!-- SYSTEME -->
        </li> <!-- SYSTEME -->

        <li>Réseaux :
                <ul>
                        <li>Commande ip</li>
                        <li>tcpdump</li>
                        <li>/etc/network/interfaces</li>
                        <li>IPv4 et ipcalc</li>
                        <li>IPv6 et ipv6calc</li>
                </ul> <!-- Réseaux -->
        </li><!-- Réseaux -->

        <li>DEV :
                <ul>
                        <li><a href="/notes-pour-plus-tard/GIT-gestion-de-version-decentralise/">GIT</a></li>
                        <li><a href="/notes-pour-plus-tard/JQ-outil-de-parsing-et-d-analyse-de-json">JQ</a></li>
                        <li><a href="/notes-pour-plus-tard/ElasticSearch-utilisation-de-l-API-par-un-adminSys">ElasticSearch</a></li>
                </ul> <!-- DEV -->
        </li><!-- DEV -->

    </ul>
     </div><!-- WELL -->
    </div><!-- ARTICLE -->
    </div><!-- ROW -->
    <hr />
    <div id="grid" class="row flex-grid">
    {% for post in site.posts %}
        <article class="box-item" itemscope="itemscope" itemtype="http://schema.org/BlogPosting" itemprop="blogPost">
            <span class="category">
                <a href="{{ site.url }}{{ site.baseurl }}/categoria/{{ post.category }}">
                    <span>{{ post.category }}</span>
                </a>
            </span>
            <div class="box-body">
                {% if post.image %}
                    <div class="cover">
                        {% include new-post-tag.html date=post.date %}
                        <a href="{{ post.url | prepend: site.baseurl }}" {%if isnewpost %}class="new-post"{% endif %}>
                            <img src="assets/img/placeholder.png" data-url="{{ post.image }}" class="preload">
                        </a>
                    </div>
                {% endif %}
                <div class="box-info">
                    <meta itemprop="datePublished" content="{{ post.date | date_to_xmlschema }}">
                    <time itemprop="datePublished" datetime="{{ post.date | date_to_xmlschema }}" class="date">
                        {% include date.html date=post.date %}
                    </time>
                    <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">
                        <h2 class="post-title" itemprop="name">
                            {{ post.title }}
                        </h2>
                    </a>
                    <a class="post-link" href="{{ post.url | prepend: site.baseurl }}">
                        <p class="description">{{ post.introduction }}</p>
                    </a>
                    <div class="tags">
                        {% for tag in post.tags %}
                            <a href="{{ site.baseurl}}/tags/#{{tag | slugify }}">{{ tag }}</a>
                        {% endfor %}
                    </div>
                </div>
            </div>
        </article>
    {% endfor %}
    </div>
</main>
