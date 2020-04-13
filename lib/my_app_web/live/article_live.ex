defmodule MyAppWeb.ArticleLive do
  use MyAppWeb, :live

  alias MyApp.Blog
  alias MyApp.Blog.Article

  @action_mount true
  def index(socket, _params) do
    articles = Blog.list_articles()
    assign(socket, articles: articles)
  end

  @action_mount true
  def new(socket, _params) do
    changeset = Blog.change_article(%Article{})
    assign(socket, changeset: changeset)
  end

  @event_handler true
  def create(socket, %{"article" => article_params}) do
    case Blog.create_article(article_params) do
      {:ok, article} ->
        socket
        |> put_flash(:info, "Article created successfully.")
        |> push_redirect(to: Routes.article_path(socket, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, changeset: changeset)
    end
  end

  @action_mount true
  def show(socket, %{"id" => id}) do
    article = Blog.get_article!(id)
    assign(socket, article: article)
  end

  @action_mount true
  def edit(socket, %{"id" => id}) do
    article = Blog.get_article!(id)
    changeset = Blog.change_article(article)
    assign(socket, article: article, changeset: changeset)
  end

  @event_handler true
  def update(socket, %{"article" => article_params}) do
    article = socket.assigns.article

    case Blog.update_article(article, article_params) do
      {:ok, article} ->
        socket
        |> put_flash(:info, "Article updated successfully.")
        |> push_redirect(to: Routes.article_path(socket, :show, article))

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, article: article, changeset: changeset)
    end
  end

  @event_handler true
  def delete(socket, %{"id" => id}) do
    article = Blog.get_article!(id)
    {:ok, _article} = Blog.delete_article(article)

    socket
    |> put_flash(:info, "Article deleted successfully.")
    |> push_redirect(to: Routes.article_path(socket, :index))
  end
end
