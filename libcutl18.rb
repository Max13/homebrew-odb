class Libcutl18 < Formula
  homepage "http://www.codesynthesis.com/projects/libcutl/"
  url "http://www.codesynthesis.com/download/libcutl/1.8/libcutl-1.8.1.tar.gz"
  sha256 "ff52e4fe742b9b9474e4bfdb485c21bc7627baec870297e504539880b1f66ac7"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <vector>
      #include <iostream>

      #include <cutl/shared-ptr.hxx>

      #include <cutl/compiler/type-info.hxx>
      #include <cutl/compiler/traversal.hxx>

      using namespace std;
      using namespace cutl;

      // Data types.
      //
      struct base
      {
        virtual ~base () {}
      };

      struct derived1: base {};
      struct derived2: base {};

      typedef vector<cutl::shared_ptr<base> > objects;

      struct init
      {
        init ()
        {
          using compiler::type_info;

          {
            type_info ti (typeid (base));
            insert (ti);
          }

          {
            type_info ti (typeid (derived1));
            ti.add_base (typeid (base));
            insert (ti);
          }

          {
            type_info ti (typeid (derived2));
            ti.add_base (typeid (base));
            insert (ti);
          }
        }
      } init_;

      // Traversers.
      //
      template <typename X>
      struct traverser: compiler::traverser_impl<X, base>,
                        virtual compiler::dispatcher<base>
      {
        void
        add_traverser (compiler::traverser_map<base>& m)
        {
          compiler::dispatcher<base>::traverser (m);
        }
      };

      typedef traverser<base> base_trav;
      typedef traverser<derived1> derived1_trav;
      typedef traverser<derived2> derived2_trav;

      struct base_impl: base_trav
      {
        virtual void
        traverse (type&)
        {
          cout << "base_impl: base" << endl;
        }
      };

      struct derived1_impl: derived1_trav
      {
        virtual void
        traverse (type&)
        {
          cout << "derived1_impl: derived1" << endl;
        }
      };

      struct combined_impl: derived1_trav, derived2_trav
      {
        virtual void
        traverse (derived1&)
        {
          cout << "combined_impl: derived1" << endl;
        }

        virtual void
        traverse (derived2&)
        {
          cout << "combined_impl: derived2" << endl;
        }
      };

      int
      main ()
      {
        objects o;
        o.push_back (cutl::shared_ptr<base> (new (shared) base));
        o.push_back (cutl::shared_ptr<base> (new (shared) derived1));
        o.push_back (cutl::shared_ptr<base> (new (shared) derived2));

        base_impl base;
        derived1_impl derived1;
        combined_impl combined;

        for (objects::iterator i (o.begin ()); i != o.end (); ++i)
          base.dispatch (**i);

        cout << endl;

        for (objects::iterator i (o.begin ()); i != o.end (); ++i)
          derived1.dispatch (**i);

        cout << endl;

        for (objects::iterator i (o.begin ()); i != o.end (); ++i)
          combined.dispatch (**i);

        cout << endl;

        base.add_traverser (derived1);
        for (objects::iterator i (o.begin ()); i != o.end (); ++i)
          base.dispatch (**i);

        cout << endl;

        derived1.add_traverser (combined);
        for (objects::iterator i (o.begin ()); i != o.end (); ++i)
          derived1.dispatch (**i);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lcutl"
    system "./test"
  end
end
