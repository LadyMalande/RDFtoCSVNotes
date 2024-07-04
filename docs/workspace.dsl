workspace "RDFtoCSV" "Pracovní složka pro diagramy RDFtoCSV" {

    model {
        otherSystem = softwareSystem "Jiný softwarový systém" "Externí systém využívající RDFtoCSV" "Existující nebo vznikající systém"

        commonUser = person "Běžný uživatel" "Chce převést RDF do CSV"
        expert = person "Pokročilý uživatel" "Chce převést RDF do CSV a mít možnost převod parametricky upravit"
        
        RDFtoCSV = softwareSystem "RDFtoCSV" "" "" {

            group "Uživatelská prostředí" {
                RDFtoCSVWebApplication = container "RDFtoCSV Webová aplikace" "Umožňuje převod dat z RDF do CSV a umožňuje přečíst si informace o RDFtoCSV" "Webová aplikace" "Webová stránka"

                RDFtoCSVCmdLine = container "RDFtoCSV Příkazový řádek" "Umožňuje volat převod dat z RDF do CSV z příkazového řádku" "Příkazový řádek" ""
            }

            RDFtoCSVlibrary = container "RDFtoCSV knihovna" "Převádí RDF do CSV" "Knihovna" "Jiný softwarový systém" {				
                input_processorComponent = component "Input Processor" "Zpracovává vstup" "package" 
                convertorComponent = component "Converter" "Převádí původní datový formát do vnitřní reprezentace pro další zpracování"
                metadata_creatorComponent = component "Metadata Creator" "Vytváří metadata" 
                metadata_enricherComponent = component "Metadata Enricher" "Obohacuje vytvořená metadata"
                output_processorComponent = component "Output processor" "Zabaluje výstupní data"

                supportComponent = component "Support" "Zpracovává různé požadavky"
            }
			
			RDFtoCSVAPI = container "RDFtoCSV backend" "Převádí RDF do CSV" "Backend" {
               RDFtoCSVAPIController = component "RDFtoCSV API" "Zpracovává požadavky" "REST" "Controller"
            }
        }

        // software system relationships
        otherSystem -> RDFtoCSV "Chce převést RDF do CSV a mít možnost převod parametricky upravit"
        commonUser -> RDFtoCSV "Chce převést RDF do CSV"
        expert -> RDFtoCSV "Chce převést RDF do CSV a mít možnost převod parametricky upravit"

        // external to container relationships
        commonUser -> RDFtoCSVWebApplication "Chce převést RDF do CSV pomocí webového uživatelského rozhraní"
        expert -> RDFtoCSVCmdLine "Chce převést RDF do CSV lokálně"
        expert -> RDFtoCSVWebApplication "Chce převést RDF do CSV pomocí webového uživatelského rozhraní"
		expert -> RDFtoCSVlibrary "Chce do knihovny přidat další funkce"
		otherSystem -> RDFtoCSVlibrary "Volá funkci převodu RDF do CSV"
		otherSystem -> RDFtoCSVAPI "Volá funkci převodu RDF do CSV"

        // container to container relationships
        RDFtoCSVWebApplication -> RDFtoCSVAPI "Posílá požadavky na převod dat"
        RDFtoCSVCmdLine -> RDFtoCSVlibrary "Sends stocking/unstocking requests"
		RDFtoCSVAPI -> RDFtoCSVlibrary "Volá funkci knihovny pro převod RDF do CSV"
		
        // backend Component relationships
        RDFtoCSVWebApplication -> RDFtoCSVAPIController "provádí volání API" "HTTPS"
        RDFtoCSVAPIController -> RDFtoCSVlibrary "Používá" 
        RDFtoCSVlibrary -> RDFtoCSVAPIController "Posílá .zip po převodu dat" ""
        input_processorComponent -> convertorComponent "Předává zpracovaná vstupní data"
        convertorComponent -> metadata_creatorComponent "Předává interní reprezentaci zpracovaných dat"
        metadata_creatorComponent ->  metadata_enricherComponent "Předává základní metadata"
        input_processorComponent -> supportComponent "Používá"
		metadata_enricherComponent -> supportComponent "Používá"
		metadata_creatorComponent -> supportComponent "Používá"
		convertorComponent -> supportComponent "Používá"
		output_processorComponent -> supportComponent "Používá"
        metadata_enricherComponent -> output_processorComponent "Předává obohacená data"
		output_processorComponent -> RDFtoCSVAPIController "Vrací .zip webové službě"
		RDFtoCSVAPIController -> RDFtoCSVWebApplication "Vrací .zip klientovi"

        deploymentEnvironment "Produkce" {
            deploymentNode "Onrender server" "" "" {

                beckendServerDeployment = deploymentNode "Nginx" "Nginx 1.18.*" "" {
                    deploymentNode "Docker" {
                        containerInstance RDFtoCSVAPI
                    }
                }

            }

                WebApplicationDeployment = deploymentNode "Počítač běžného uživatele" "" "" {
                deploymentNode "Webový prohlížeč" "" "" {
                    containerInstance RDFtoCSVWebApplication
                }
            }


            RDFtoCSVCmdLineDeployment = deploymentNode "Počítač pokročilého uživatele" "" "" {
                deploymentNode "Java" "Java 17" "" {
                    containerInstance RDFtoCSVCmdLine
                }
            }

            // Relationships
            WebApplicationDeployment -> beckendServerDeployment "Posílá požadavky na backend"
        }
    }

    views {
	terminology {
    person Osoba
    softwareSystem "Softwarový systém"
    container Kontejner
    component Komponenta
    deploymentNode Deployment
    infrastructureNode <term>
    relationship Vztah
}
        systemContext RDFtoCSV "RDFtoCSVContextDiagram" {
		title "Diagram systémového kontextu pro RDFtoCSV"
            include *
			exclude "input_processorComponent -> otherSystem"
			autoLayout
        }

        container RDFtoCSV "RDFtoCSVContainerDiagram" {
            include *
            autoLayout
        }

        component RDFtoCSVlibrary "RDFtoCSVlibraryComponentDiagram" {
            include *
            autoLayout
        }

        component RDFtoCSVlibrary "Warehouseinput_processorComponentDiagram" {
            title "Warehouse Ordering/Management Component Diagram"

            include RDFtoCSVWebApplication
            include RDFtoCSVAPIController
            include input_processorComponent
            include output_processorComponent
            include supportComponent
            include otherSystem
            autoLayout
        }

        component RDFtoCSVlibrary "Diagram" {
            title "Package Lifecycle Component Diagram"

            include RDFtoCSVCmdLine
            include convertorComponent

            include metadata_enricherComponent

            include supportComponent
            autoLayout
        }

 
        
        deployment RDFtoCSV "Produkce" "productionDeploymentDiagram" {
            include *
            exclude "RDFtoCSVCmdLine -> RDFtoCSVlibrary"
            autoLayout
        }

        dynamic RDFtoCSVWebApplication "OrderingDynamicView" "Placing an order with the otherSystem scenario"  {

        }

        theme default

        styles {
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Gateway" {
                shape Pipe
            }

            element "Website" {
                shape WebBrowser
            }

            element "Mobile" {
                shape MobileDevicePortrait
            }

            element "Controller" {
                shape Pipe
            }
        }
    }
    configuration {
        scope softwaresystem
    }
}
